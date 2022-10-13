drop table if exists message;
drop table if exists closure;

create table if not exists message(
    id int NOT NULL,
    parent_message_id int,
    text varchar(255),
    created_at timestamp,
    PRIMARY KEY (id),
    FOREIGN KEY(parent_message_id) REFERENCES message(id)
);

create table if not exists closure(
    parent_id int,
    child_id int,
    depth int,
    PRIMARY KEY (parent_id, child_id)
);

insert into message(id, text, created_at) values (1, "1: 昨日何時に寝た？", now());
insert into message(id, text, created_at) values (2, "2: >>1 ８時", now());
insert into message(id, text, created_at) values (3, "3: >>1 １１時", now());

insert into message(id, text, created_at) values (4, "4: >>2 早い！", now());
insert into message(id, text, created_at) values (5, "5: >>2 なんでそんな早い？", now());

-- B（第一階層）
insert into closure(parent_id, child_id) values (1, 1);
insert into closure(parent_id, child_id) values (2, 2);
insert into closure(parent_id, child_id) values (3, 3);
insert into closure(parent_id, child_id) values (4, 4);
insert into closure(parent_id, child_id) values (5, 5);
-- B（第二階層）
insert into closure(parent_id, child_id) values (1, 2);
insert into closure(parent_id, child_id) values (1, 3);
-- B（第三階層）
insert into closure(parent_id, child_id) values (1, 4);
insert into closure(parent_id, child_id) values (2, 4);
insert into closure(parent_id, child_id) values (1, 5);
insert into closure(parent_id, child_id) values (2, 5);

-- メッセージID1に紐づくレコードを取得
select message.text, closure.parent_id, closure.child_id from message
left join closure on message.id = closure.child_id 
where closure.parent_id = 1;

-- # text, parent_id, child_id
-- '1: 昨日何時に寝た？', '1', '1'
-- '2: >>1 ８時', '1', '2'
-- '3: >>1 １１時', '1', '3'
-- '4: >>2 早い！', '1', '4'
-- '5: >>2 なんでそんな早い？', '1', '5'
