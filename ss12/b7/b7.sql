create database ss10_7;
use ss10_7;

create table departments(
	dept_id int primary key auto_increment,
    name varchar(100) not null,
    manager varchar(100) not null,
    budget decimal(15,2) not null
);

create table employees(
	emp_id int primary key auto_increment,
    name varchar(100) not null,
    dept_id int not null,
    salary decimal(10,2) not null,
    hire_date date not null,
    foreign key(dept_id) references departments(dept_id)
);

create table projects(
	project_id int primary key auto_increment,
    name varchar(100) not null,
    emp_id int not null,
    start_date date not null,
    end_date date not null,
    status varchar(50) not null,
    foreign key(emp_id) references employees(emp_id)
);
-- 2) Tạo trigger BEFORE INSERT trên bảng employees
DELIMITER //
create trigger before_employee_insert
before insert on employees
for each row
begin
    if new.salary < 500 then
        signal sqlstate '45000'
        set message_text = 'Error: Salary must be at least 500.';
    end if;
    if not exists (select 1 from departments where dept_id = new.dept_id) then
        signal sqlstate '45000'
        set message_text = 'Error: Department does not exist.';
    end if;
    if not exists (select 1 from projects p 
        join employees e on p.emp_id = e.emp_id
        where e.dept_id = new.dept_id and p.status <> 'Completed'
    ) then
        signal sqlstate '45000'
        set message_text = 'Error: All projects in this department are already completed.';
    end if;
end //
DELIMITER ;
-- 3) Tạo trigger AFTER UPDATE trên bảng projects
create table project_warnings (
    warning_id int primary key auto_increment,
    project_id int not null,
    warning_message varchar(255) not null,
    foreign key (project_id) references projects(project_id)
);

create table dept_warnings (
    warning_id int primary key auto_increment,
    dept_id int not null,
    warning_message varchar(255) not null,
    foreign key (dept_id) references departments(dept_id)
);

DELIMITER //
create trigger after_project_update
after update on projects
for each row
begin
    if new.status = 'Delayed' then
        insert into project_warnings (project_id, warning_message)
        values (new.project_id, 'Warning: Project is delayed.');
    end if;
    if new.status = 'Completed' then
        if new.end_date is null then
            update projects
            set end_date = curdate()
            where project_id = new.project_id;
        end if;
        if (
            (select sum(e.salary) 
             from employees e 
             where e.dept_id = (select dept_id from employees where emp_id = new.emp_id)
            ) 
            > 
            (select d.budget 
             from departments d 
             join employees e on d.dept_id = e.dept_id 
             where e.emp_id = new.emp_id
             limit 1)
        ) then
            insert into dept_warnings (dept_id, warning_message)
            values (
                (select dept_id from employees where emp_id = new.emp_id),
                'Warning: Department budget exceeded due to high salaries.'
            );
        end if;
    end if;
end//
DELIMITER ;
-- 4) Tạo view FullOverview để quan sát được tổng quan 
create view FullOverview 
as
select e.emp_id,e.name as employee_name,d.name as department_name,p.name as project_name,p.status,concat('$', format(e.salary, 2)) as salary,pw.warning_message
from employees e
left join departments d on e.dept_id = d.dept_id
left join projects p on e.emp_id = p.emp_id
left join project_warnings pw on p.project_id = pw.project_id;
-- 5) Tiến hành chạy các câu lệnh sau để kiểm tra
INSERT INTO employees (name, dept_id, salary, hire_date)
VALUES ('Alice', 1, 400, '2023-07-01'); 

INSERT INTO employees (name, dept_id, salary, hire_date)
VALUES ('Bob', 999, 1000, '2023-07-01'); 

INSERT INTO employees (name, dept_id, salary, hire_date)
VALUES ('Charlie', 2, 1500, '2023-07-01');

INSERT INTO employees (name, dept_id, salary, hire_date)
VALUES ('David', 1, 2000, '2023-07-01');
-- 6) Tiến hành chạy các câu lệnh sau để kiểm tra
UPDATE projects SET status = 'Delayed' WHERE project_id = 1;
UPDATE projects SET status = 'Completed', end_date = NULL WHERE project_id = 2;
UPDATE projects SET status = 'Completed' WHERE project_id = 3;
UPDATE projects SET status = 'In Progress' WHERE project_id = 4;
-- 7) Hiển thị lại VIEW và quan sát
select * from FullOverview;
