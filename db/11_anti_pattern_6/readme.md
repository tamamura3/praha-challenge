# 課題1
- ステータスのような、カラムに入れる値を限定したい場合

## 方法1 Check制約
- Chech制約を使い値を指定することで、カラムに入れる値を限定できる
- status: varchar CHECK(status IN ("studying","graduated","suspended"))

### メリット
- 制約を設けるだけで値を限定できる 

### デメリット
- 値を変更する時が大変
    - Check制約で指定した値を変更する場合、該当するレコードをすべて更新する必要がある。削除するときも一緒。

## 方法2 ステータスを別テーブルで管理
- statusテーブルを作り、値を管理する
- 他のテーブルはこのstatusテーブルのidを外部参照する
```mermaid
erDiagram
    status {
        int id PK
        string name
    }
```

### メリット
- 値の変更が簡単
    - statusテーブルの値を変更すれば良いだけ
### デメリット
- statusを検索する時はjoinが必要
    - 多対１なので検索のコストは低いため実際はデメリットにはならない
# 課題2
```mermaid
erDiagram
    student }o--|| status : has
    student {
        id varchar PK
        name varchar
    }
    status {
        id int PK
        name string
    }
```

# 課題3
- 自動販売機を管理するシステム。稼働中、停止中、故障中のステータスを持たせようとして今回のアンチパターンに陥る。