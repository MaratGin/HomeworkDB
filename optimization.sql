create table department (
  "id" serial primary key ,
  "name" varchar(100)
);

create table employee(
  "id" serial primary key ,
  "department_id" integer,
  "chief_id" integer constraint valid_chief check ( id <> employee.chief_id ),
  "name" varchar(100),
  "salary" integer,
  "number" varchar(11),

foreign key (department_id) references department(id)

);


alter table employee
    add constraint emp_phone check (number is not null);



--indexes
create index number on employee using hash(number);
create index department_id on employee using hash(department_id);
create index chief_id on employee using hash(chief_id);
create index name on employee using hash(name);





insert into department (name) values ('Sales');
insert into department (name) values ('Engineering');
insert into department (name) values ('Training');
insert into department (name) values ('Sales');
insert into department (name) values ('Support');
insert into department (name) values ('Sales');
insert into department (name) values ('Business Development');
insert into department (name) values ('Sales');
insert into department (name) values ('Training');
insert into department (name) values ('Engineering');


INSERT INTO employee (department_id, chief_id, name, salary, number)
select
 ceil(random()*10),
 ceil(random()* (select count(*) from employee)),
substr(md5(random()::text), 1, ceil(random()*10)::integer),
ceil(random()*100000),
ceil(random()*99999999 + 10000000)
    from generate_series(1,1000000);

-- Task 1
--Вывести список сотрудников, получающих заработную плату большую чем у непосредственного руководителя
create view employee_salary
as
select e1.name,
       e1.salary as employee_salary,
       e2.salary as chief_salary,
       d.name as department_name
from employee as e1
left join employee e2 on e1.chief_id = e2.id
left join department d on d.id = e1.department_id
where e1.salary > e2.salary
limit 10;


-- Task 2
--Вывести список сотрудников, получающих максимальную заработную плату в своем отделе

select * from department d
left join employee e on e.department_id = d.id
where e.salary = (select max(salary) from employee e where e.department_id = d.id);

--Task 3
--Вывести список ID отделов, количество сотрудников в которых не превышает 3 человек
 explain select * from department d
where (select count(e1) from employee e1 where e1.department_id = d.id ) <= 3;

--Task 4
--Вывести список сотрудников, не имеющих назначенного руководителя, работающего в том-же отделе
explain select distinct e2.* from employee e1
inner join employee e2 on e1.id = e2.chief_id and e1.department_id != e2.department_id;

--Task 5
--Найти список ID отделов с максимальной суммарной зарплатой сотрудников

  with  id_sum as (select e.department_id, sum(salary) as salary
    from   employee e
    group  by department_id)
  select distinct i1.department_id from id_sum i1
       join id_sum i on i1.salary =(select max(salary) from id_sum);



