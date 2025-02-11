create table Departments(
	department_id int primary key,
    department_name varchar(255),
    location varchar(255)
);

create table Employees(
	employee_id int primary key,
    name varchar(255),
    dob date,
    department_id int,
    foreign key(department_id) references Departments(department_id),
    salary decimal(10,2)
);

create table Timesheets(
	timesheet_id int primary key,
    enployee_id int,
    project_id int,
    foreign key(enployee_id) references Employees(enployee_id),
    foreign key(project_id) references Projects(project_id),
    work_date date,
    hours_worked decimal(5,2) 
);

create table Projects(
	project_id int primary key,
    project_name varchar(255),
    star_date date ,
    end_date date
);

create table WorkReports(
	report_id int primary key,
    employee_id int,
    foreign key (employee_id) references Employees(employee_id),
    report_date date,
    report_content text
);

insert into departments (department_id, department_name, location) 
values (1, 'IT', 'Hanoi'),
       (2, 'HR', 'Ho Chi Minh');

insert into projects (project_id, project_name, start_date, end_date) 
values (1, 'Website Development', '2024-01-01', '2024-06-30'),
       (2, 'Mobile App', '2024-02-15', '2024-08-15');

insert into employees (employee_id, name, dob, department_id, salary) 
values (1, 'Nguyen Van A', '1990-05-15', 1, 20000000.00),
       (2, 'Tran Thi B', '1995-10-20', 2, 15000000.00);

insert into timesheets (timesheet_id, employee_id, project_id, work_date, hours_worked) 
values (1, 1, 1, '2024-02-01', 8.00),
       (2, 2, 2, '2024-02-02', 7.50);

insert into workreports (report_id, employee_id, report_date, report_content) 
values (1, 1, '2024-02-03', 'Completed UI design for the website'),
       (2, 2, '2024-02-04', 'Finished testing module for mobile app');

-- 4) Hãy cập nhật thông tin của một dự án bất kì
update projects 
set project_name = 'E-commerce Website' 
where project_id = 1;
-- 5) Hãy xóa thông tin của một employee bất kì 
delete from employees where employee_id = 2;

