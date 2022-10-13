drop table if exists manga_comment;
drop table if exists novel_comment;
drop table if exists manga;
drop table if exists novel;
drop table if exists comment;

create table if not exists manga (
    id int NOT NULL AUTO_INCREMENT,
    name varchar(255),
    PRIMARY KEY (id)
);

create table if not exists novel(
    id int NOT NULL AUTO_INCREMENT,
    name varchar(255),
    PRIMARY KEY (id)
);

create table if not exists comment(
    id int NOT NULL AUTO_INCREMENT,
    text varchar(255),
    created_at datetime,
    PRIMARY KEY (id)
);

create table if not exists manga_comment(
    manga_id int,
    comment_id int,
    FOREIGN KEY(manga_id) REFERENCES manga(id),
    FOREIGN KEY(comment_id) REFERENCES comment(id),
    PRIMARY KEY(manga_id, comment_id)
);

create table if not exists novel_comment(
    novel_id int,
    comment_id int,
    FOREIGN KEY(novel_id) REFERENCES novel(id),
    FOREIGN KEY(comment_id) REFERENCES comment(id),
    PRIMARY KEY(novel_id, comment_id)
);

insert into manga (id, name) values (1, "HUNTER HUNTER");
insert into manga (id, name) values (2, "JOJO");
insert into manga (id, name) values (3, "NARUTO");

insert into comment (id, text, created_at) values (1, "comment 1", now());
insert into comment (id, text, created_at) values (2, "comment 2", now());
insert into comment (id, text, created_at) values (3, "comment 3", now());

insert into manga_comment (manga_id, comment_id) values (1, 1);
insert into manga_comment (manga_id, comment_id) values (2, 2);
insert into manga_comment (manga_id, comment_id) values (2, 3);


insert into novel (id, name) values (1, "Harry Potter");
insert into novel (id, name) values (2, "Mujuryoku Piero");
insert into novel (id, name) values (3, "The Lord of the Rings");

insert into comment (id, text, created_at) values (4, "comment 4", now());
insert into comment (id, text, created_at) values (5, "comment 5", now());
insert into comment (id, text, created_at) values (6, "comment 6", now());

insert into novel_comment (novel_id, comment_id) values (1, 4);
insert into novel_comment (novel_id, comment_id) values (3, 5);
insert into novel_comment (novel_id, comment_id) values (3, 6);



-- 漫画一覧と各コメントを検索
select m.id, m.name, c.text from manga m
left join manga_comment mc on m.id = mc.manga_id
left join comment c on c.id = mc.comment_id;

-- # id, name, text
-- '1', 'HUNTER HUNTER', 'comment 1'
-- '2', 'JOJO', 'comment 2'
-- '2', 'JOJO', 'comment 3'
-- '3', 'NARUTO', NULL

-- 小説をすべて検索
select * from novel;

-- # id, name
-- '1', 'Harry Potter'
-- '2', 'Mujuryoku Piero'
-- '3', 'The Lord of the Rings'

-- コメントを削除
delete from manga_comment where comment_id = 1;
delete from comment where id = 1;