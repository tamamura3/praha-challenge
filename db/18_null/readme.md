# 課題1
## データベースでNULLを比較するには
データベースにおけるNULLは、等号（＝）、等号否定（！＝）、不等号（＜＞≦≧）で比較する対象にならない。  
例えば、SELECT * FROM Users WHERE email = NULL;を実行しても、emailの値がNULLのレコードは返らない。  
結果は0行になる。  

そのため、データベースでNULLを条件にするには、IS NULL、IS NOT NULLという専用の命令句を使う必要がある。

## 3値論理とNULLについて
SQLの論理体系はtrue、false、unknownの3値論理と呼ばれている。  
プログラミング言語での真理値はtrueとfalseの2値論理なので、プログラミング言語とこの点が異なる。  
SQLが3値なのはNULLが原因であり、リレーショナルデータベースにNULLを持ち込んだため、unknownという3つめの値が必要になったという背景がある。  

データベースにおけるNULLは値がない状態であり、trueにもfalseにもなり得るという扱いで、unknownで表現する。  
例えNULL同士を比較してもtureにはならない。なぜならNULLはtrueにもfalseにもなり得るので、値が決まっていない以上比較のしようがないから。  

プログラミング言語でNULLの比較ができるのは、例えばC言語においてはNULLが定数として定義されているため。

参考：
https://codezine.jp/article/detail/532

## 各条件文の結果

SELECT NULL = 0;  
-- NULL（unknown）を0と比較できないため、結果は「NULL」（unknown）

NULL = NULL  
-- NULL（unknown）同士を比較できないため、結果は「NULL」（unknown）  
-- NULLは値が決まっていないので、NULL同士でも比較できない

NULL <> NULL  
-- NULL（unknown）同士を比較できないため、結果は「NULL」（unknown）

NULL AND TRUE  
-- NULLがTRUEなら、TRUE AND TRUEで真  
-- NULLがFALSEなら、FALSE AND TRUEで偽  
-- NULLの値により答えが変わるので、結果は「NULL」（unknown）

NULL AND FALSE  
-- NULLがTRUEなら、TRUE AND FALSEで偽  
-- NULLがFALSEなら、FALSE AND FALSEで偽  
-- NULLの値に関わらず答えはFALSEになるので、結果は「0」（FALSE）

NULL OR TRUE  
-- NULLがTRUEなら、TRUE OR TRUEで真  
-- NULLがFALSEなら、FALSE OR TRUEで真  
-- NULLの値に関わらず答えはTRUEになるので、結果は「1」（TRUE）

NULL IS NULL  
-- IS NULLならNULLを比較できるので、結果は「1」（TRUE）

NULL IS NOT NULL  
-- 結果は「0」（FALSE）

# 課題2
```mermaid
erDiagram
Assignee {
    id int PK
    name varchar 
}
Issue {
    id int PK
    text varchar 
    assigned_to_id int FK
}
Assignee |o--o{ Issue:""
```

# 課題3
BOOLEANならFALSE
INTなら0
TEXTなら''

# 課題4
NULLに関するクイズ