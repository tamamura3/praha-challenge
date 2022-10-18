drop table if exists status;
drop table if exists student;

create table if not exists student (
    id int AUTO_INCREMENT,
    name varchar,
    status_id int,
    PRIMARY KEY(id),
    FOREIGN KEY status_id REFERENCES status(id)
);

create table if not exists status{
    id int AUTO_INCREMENT,
    name varchar,
    PRIMARY KEY(id)
}

insert into student (name, status_id) values ("Aさん", 1);
insert into student (name, status_id) values ("Bさん", 3);
insert into student (name, status_id) values ("Cさん", 3);

insert into status(name) values ("studying");
insert into status(name) values ("graduated");
insert into status(name) values ("teigaku");

-- teigakuをsuspendedに変更
update status set name = "suspended" where id = 3;

-- suspendedを削除
delete from student where status_id = 3;
delete from status where id = 3;
