USE ss12;
-- 2) Tạo bảng budget_warnings để lưu thông tin cảnh báo ngân sách
create table budget_warnings (
	warning_id int primary key auto_increment,
    project_id int not null,
    warning_message varchar(255) not null
);
-- 3) Tạo trigger AFTER UPDATE trên bảng projects
DELIMITER //
create trigger after_project_update
after update on projects
for each row
begin
    if new.total_salary > new.budget then
        if not exists (
            select 1 from budget_warnings 
            where project_id = new.project_id 
            and warning_message = 'Budget exceeded due to high salary'
        ) then
            insert into budget_warnings (project_id, warning_message) 
            values (new.project_id, 'Budget exceeded due to high salary');
        end if;
    end if;
end //
DELIMITER ;
-- 	4) Tạo view ProjectOverview để hiển thị thông tin chi tiết về dự án
create view ProjectOverview 
as
select p.project_id,p.name as project_name,p.budget,p.total_salary,bw.warning_message
from projects p
left join budget_warnings bw on p.project_id = bw.project_id;
-- 5) Tiến hành thêm nhân viên sau:
INSERT INTO workers (name, project_id, salary) VALUES ('Michael', 1, 6000.00);
INSERT INTO workers (name, project_id, salary) VALUES ('Sarah', 2, 10000.00);
INSERT INTO workers (name, project_id, salary) VALUES ('David', 3, 1000.00);

-- 6) Hiển thị lại bảng budget_warnings và view ProjectOverview để kiểm chứng
select * from budget_warnings;
select * from ProjectOverview;