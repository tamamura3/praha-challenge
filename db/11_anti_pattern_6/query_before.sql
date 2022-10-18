drop table if exists student;

create table if not exists student (
    id int AUTO_INCREMENT,
    name varchar(255),
    status varchar(255),
    PRIMARY KEY(id),
    constraint ch CHECK(status in ('studying', 'graduated', 'teigaku'))
);

insert into student (name, status) values ("Aさん", "studying");
insert into student (name, status) values ("Bさん", "teigaku");
insert into student (name, status) values ("Cさん", "teigaku");

-- teigakuをsuspendedに変更
-- safeモード外さないと実行できない
ALTER TABLE student DROP CONSTRAINT ch;
update student set status = "teigaku" where status = "suspended";
alter table student add constraint ch CHECK(status in ("studying", "graduated", "suspended"));

-- suspendedを削除
ALTER TABLE student DROP CONSTRAINT ch;
delete from student where status = "suspended";
alter table student add constraint ch CHECK(status in ("studying", "graduated"));