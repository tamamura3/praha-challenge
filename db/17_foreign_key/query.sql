drop table if exists Employee;
drop table if exists Department;


-- 部署
create table Department (
    id int auto_increment primary key,
    name varchar(255)
);
-- 社員
create table Employee (
    id int auto_increment primary key,
    name varchar(255),
    department_id int,
    foreign key (department_id) references Department (id) on delete cascade on update cascade
);

insert into Department (name) values ("営業");
insert into Department (name) values ("マーケティング");
insert into Department (name) values ("会計");

insert into Employee (name, department_id) values ("田中", 1);
insert into Employee (name, department_id) values ("鈴木", 2);
insert into Employee (name, department_id) values ("斎藤", 3);

select * from Department;
-- # id, name
-- '1', '営業'
-- '2', 'マーケティング'
-- '3', '会計'

select * from Employee;
# id, name, department_id
-- '1', '田中', '1'
-- '2', '鈴木', '2'
-- '3', '斎藤', '3'


-- 部署テーブルから営業を削除
-- cascadeなので、社員テーブルから田中も削除される
-- delete from Department where id = 1;

-- # id, name
-- '2', 'マーケティング'
-- '3', '会計'

-- # id, name, department_id
-- '2', '鈴木', '2'
-- '3', '斎藤', '3'



-- 部署テーブルの営業のidを更新
-- cascadeなので、社員テーブルの田中のdepartment_idも変更される
-- update Department set id = 11 where id = 1;

-- # id, name
-- '2', 'マーケティング'
-- '3', '会計'
-- '11', '営業'

-- # id, name, department_id
-- '1', '田中', '11'
-- '2', '鈴木', '2'
-- '3', '斎藤', '3'