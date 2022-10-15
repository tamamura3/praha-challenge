# 課題1
- 問題のテーブルでは「面談をした日付」や「電話の内容メモ」など、複数回発生するようなデータをカラムとして管理している。  
そのため、複数のデータが必要な場合でも一つしか登録できず、問題が生じる。
- 電話の内容や面談など、新規顧客とは切り離せる概念が新規顧客テーブルに集まっている。そのため、テーブルが肥大化しメンテナンスが大変になる。

# 課題2
- 以下のような別々の概念は分けてテーブルを作成する
    - 電話
    - 面談
    - 制約

![](anti_pattern_5_1.png)
```puml
@@startuml

entity new_customer{
    id
    --
    name
}
entity call_history {
    id
    --
    new_customer_id [FK]
    note -- 電話の内容
    call_date -- 電話した日時
    create_at -- 作成日時
}
entity meeting_history {
    id
    --
    new_customer_id [FK]
    note -- 面談した内容
    meeting_date -- 面談した日時
    create_at -- 作成日時
}
entity closing_status {
    id
    --
    new_customer_id [FK]
    closing_date -- 成約日時
    cancel_date -- 解約日時
    created_at -- 作成日時
}
new_customer -- call_history
new_customer -- meeting_history
new_customer -- closing_status

@@enduml
```

# 課題3
- 顧客管理システムで顧客の既婚/未婚の情報を管理するとする。複数回結婚した場合の履歴が残せず、今回のアンチパターンに陥る。