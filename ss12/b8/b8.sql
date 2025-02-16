create database ss10_8;
use ss10_8;
-- 2) Tạo bảng salary_history để ghi nhận lịch sử thay đổi lương của nhân viên
create table salary_history (
    history_id int auto_increment primary key,
    emp_id int not null,
    old_salary decimal(10, 2) not null,
    new_salary decimal(10, 2) not null,
    change_date datetime not null,
    foreign key (emp_id) references employees(emp_id)
);

-- 3) Tạo bảng salary_warnings để ghi nhận cảnh báo lương
create table salary_warnings (
    warning_id int auto_increment primary key,
    emp_id int not null,
    warning_message varchar(255) not null,
    warning_date datetime not null,
    foreign key (emp_id) references employees(emp_id)
);

-- 4) Tạo trigger AFTER UPDATE trên bảng employees:
DELIMITER //
create trigger after_salary_update
after update on employees
for each row
begin
    insert into salary_history (emp_id, old_salary, new_salary, change_date)
    values (old.emp_id, old.salary, new.salary, now());
    if new.salary < old.salary * 0.7 then
        insert into salary_warnings (emp_id, warning_message, warning_date)
        values (new.emp_id, 'lương giảm hơn 30%', now());
    end if;
    if new.salary > old.salary * 1.5 then
        set new.salary = old.salary * 1.5;
        insert into salary_warnings (emp_id, warning_message, warning_date)
        values (new.emp_id, 'lương tăng vượt quá giới hạn cho phép (đã điều chỉnh thành 150% lương cũ)', now());
    end if;
end //
DELIMITER ;

-- 5) Tạo trigger AFTER INSERT trên bảng projects:
DELIMITER //
create trigger after_project_insert
after insert on projects
for each row
begin
    declare active_project_count int;
    select count(*) into active_project_count
    from projects
    where emp_id = new.emp_id and status = 'in progress';
    if active_project_count > 3 then
        signal sqlstate '45000'
        set message_text = 'nhân viên đã tham gia hơn 3 dự án đang hoạt động';
    end if;
    if new.status = 'in progress' and new.start_date > now() then
        signal sqlstate '45000'
        set message_text = 'ngày bắt đầu của dự án là trong tương lai, nhưng trạng thái là "in progress"';
    end if;
end //
DELIMITER ;

-- 6) Tạo view PerformanceOverview:
create view PerformanceOverview 
as
select p.project_id, p.name as project_name, count(e.emp_id) as employee_count, datediff(p.end_date, p.start_date) as total_days, p.status
from projects p
left join employees e on p.emp_id = e.emp_id
group by p.project_id, p.name, p.end_date, p.start_date, p.status;

-- 7) Thay đổi lương để kiểm chứng trigger AFTER UPDATE
update employees set salary = salary * 0.5 where emp_id = 1; 

update employees
set salary = salary * 2
where emp_id = 2; 

-- 8) Thêm dự án mới để kiểm chứng trigger AFTER INSERT
insert into projects (name, emp_id, start_date, status) 
values ('new project 1', 1, curdate(), 'in progress');
insert into projects (name, emp_id, start_date, status) 
values ('new project 2', 1, curdate(), 'in progress');
insert into projects (name, emp_id, start_date, status) 
values ('new project 3', 1, curdate(), 'in progress');
insert into projects (name, emp_id, start_date, status) 
values ('new project 4', 1, curdate(), 'in progress'); 

insert into projects (name, emp_id, start_date, status) 
values ('future project', 2, date_add(curdate(), interval 5 day), 'in progress');

-- 9) Hiển thị lại VIEW và quan sát
select * from PerformanceOverview;
