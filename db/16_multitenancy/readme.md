# 課題1
## 基礎知識：マルチテナントとは？
Saasなど無関係な複数のユーザーが使用するサービスおいて、一つのWeb/DBサーバーを複数のユーザーで共有すること。
テナント間でコンテクストが分離されているので、各テナントは自身のデータにしかアクセスができない。

## where句のつけ忘れをどうやったら防げたか
- PostgreSQLのRow Level Securityを利用する
    - current_user（現在のユーザー名）と各テーブルのテナントIDカラムを比較するようなポリシーを作れば良さそう
    - そのためにはテナントIDカラムを各テーブルに作る必要がある
    - 詳細は課題3を参照  

    https://aws.amazon.com/blogs/database/multi-tenant-data-isolation-with-postgresql-row-level-security/
- DBアクセス時に参照・作成・更新・削除に自動的にテナントIDのチェックを入れるようにする
    - 例えばO/Rマッパーなどで実現できるらしいが詳細まで見れていない

# 課題2
## テナントごとにデータベースを分割する場合
メリット
- 他テナントの影響を受けにくい
- カスタマイズ性が高い  

デメリット
- スケーリングのコストが高い
    - テナント数＝DB数なので、テナントが急増した時など管理コストがかかる
  
https://docs.aws.amazon.com/ja_jp/wellarchitected/latest/saas-lens/silo-isolation.html
## テナントごとにスキーマを分割する
メリット
- 他2つの中間の特徴を持つ
    - 前の方法に比べ、テナントごとにデータベースを作成するコストはかからないいなど。

デメリット
- 他テナントのデータにアクセスするセキュリティリスク

https://docs.aws.amazon.com/ja_jp/wellarchitected/latest/saas-lens/bridge-model.html
## 全てのテナントで同じスキーマを使う
メリット
- マイグレーション（alter, update）がしやすい
- テナントをまたいだデータの共有がしやすい
    - 例えば会社の業績管理をするサービスで、複数の企業に投資する投資家のユーザーが、投資先の会社の情報を横ぐしで確認したい場合。スキーマやDBが分かれていると複雑な作りになってしまう。

デメリット
- 他テナントのデータにアクセスするセキュリティリスク


https://docs.aws.amazon.com/ja_jp/wellarchitected/latest/saas-lens/pool-isolation.html

https://www.sentryone.com/blog/multi-tenancy-with-sql-server-part-2-approaches  
https://learn.microsoft.com/ja-jp/azure/azure-sql/database/saas-tenancy-app-design-patterns?view=azuresql

## PostgreSQLのRow Level Securityとは？
PostgreSQL Row Level Security(RLS)はテーブルの行レベルでユーザーのアクセスを制御する機能。
利用例としては、複数ユーザーのデータが同じテーブル存在する場合（マルチテナントで全てのデータを同じスキーマで扱うパターンなど）に、関係のないデータにユーザーがアクセスできないよう制限するために使うことができる。

以下に公式サイトから引用したコードを載せる。  
https://www.postgresql.jp/document/9.6/html/ddl-rowsecurity.html

次の例では、まずpasswdテーブルに対してRLSを有効化している。
そしてpublicユーザー（一般）には特定の列のselectと、自身の行（passwd.user_nameが自身のユーザー名）だけのupdateを許可している。
adminユーザー（管理者）はすべてのCRUD全てを許可している。
```sql
-- passwdファイルに基づく簡単な例
CREATE TABLE passwd (
  user_name             text UNIQUE NOT NULL,
  pwhash                text,
  uid                   int  PRIMARY KEY,
  gid                   int  NOT NULL,
  real_name             text NOT NULL,
  home_phone            text,
  extra_info            text,
  home_dir              text NOT NULL,
  shell                 text NOT NULL
);

CREATE ROLE admin;  -- 管理者
CREATE ROLE bob;    -- 一般ユーザ
CREATE ROLE alice;  -- 一般ユーザ

-- テーブルに値を入れる
INSERT INTO passwd VALUES
  ('admin','xxx',0,0,'Admin','111-222-3333',null,'/root','/bin/dash');
INSERT INTO passwd VALUES
  ('bob','xxx',1,1,'Bob','123-456-7890',null,'/home/bob','/bin/zsh');
INSERT INTO passwd VALUES
  ('alice','xxx',2,1,'Alice','098-765-4321',null,'/home/alice','/bin/zsh');

-- テーブルの行単位セキュリティを有効にする
ALTER TABLE passwd ENABLE ROW LEVEL SECURITY;

-- ポリシーを作成する
-- 管理者はすべての行を見ることができ、どんな行でも追加できる
CREATE POLICY admin_all ON passwd TO admin USING (true) WITH CHECK (true);
-- 一般ユーザはすべての行を見ることができる
CREATE POLICY all_view ON passwd FOR SELECT USING (true);
-- 一般ユーザは自身のレコードを更新できるが、
-- 変更できるのは使用するシェルだけに制限する
CREATE POLICY user_mod ON passwd FOR UPDATE
  USING (current_user = user_name)
  WITH CHECK (
    current_user = user_name AND
    shell IN ('/bin/bash','/bin/sh','/bin/dash','/bin/zsh','/bin/tcsh')
  );

-- adminにはすべての通常の権限を付与する
GRANT SELECT, INSERT, UPDATE, DELETE ON passwd TO admin;
-- 一般ユーザは公開列にSELECTでアクセスできるだけとする
GRANT SELECT
  (user_name, uid, gid, real_name, home_phone, extra_info, home_dir, shell)
  ON passwd TO public;
-- 特定の列についてはユーザによる更新を許可する
GRANT UPDATE
  (pwhash, real_name, home_phone, extra_info, shell)
  ON passwd TO public;
```

テーブルを実際に操作する例。
Aliceという一般ユーザーで試した場合、設定通り公開列のselectと自身の行の更新しか実行できない。
```sql
-- adminはすべての行と列を見ることができる
postgres=> set role admin;
SET
postgres=> table passwd;
 user_name | pwhash | uid | gid | real_name |  home_phone  | extra_info | home_dir    |   shell
-----------+--------+-----+-----+-----------+--------------+------------+-------------+-----------
 admin     | xxx    |   0 |   0 | Admin     | 111-222-3333 |            | /root       | /bin/dash
 bob       | xxx    |   1 |   1 | Bob       | 123-456-7890 |            | /home/bob   | /bin/zsh
 alice     | xxx    |   2 |   1 | Alice     | 098-765-4321 |            | /home/alice | /bin/zsh
(3 rows)

-- Test what Alice is able to do
postgres=> set role alice;
SET
postgres=> table passwd;
ERROR:  permission denied for relation passwd
postgres=> select user_name,real_name,home_phone,extra_info,home_dir,shell from passwd;
 user_name | real_name |  home_phone  | extra_info | home_dir    |   shell
-----------+-----------+--------------+------------+-------------+-----------
 admin     | Admin     | 111-222-3333 |            | /root       | /bin/dash
 bob       | Bob       | 123-456-7890 |            | /home/bob   | /bin/zsh
 alice     | Alice     | 098-765-4321 |            | /home/alice | /bin/zsh
(3 rows)

postgres=> update passwd set user_name = 'joe';
ERROR:  permission denied for relation passwd
-- Aliceは自分のreal_nameを変更できるが、他は変更できない
postgres=> update passwd set real_name = 'Alice Doe';
UPDATE 1
postgres=> update passwd set real_name = 'John Doe' where user_name = 'admin';
UPDATE 0
postgres=> update passwd set shell = '/bin/xx';
ERROR:  new row violates WITH CHECK OPTION for "passwd"
postgres=> delete from passwd;
ERROR:  permission denied for relation passwd
postgres=> insert into passwd (user_name) values ('xxx');
ERROR:  permission denied for relation passwd
-- Aliceは自分のパスワードを変更できる。
-- RLSにより他の行は更新されないが、何も報告されない。
postgres=> update passwd set pwhash = 'abc';
UPDATE 1
```

