-- Insert sample data into Departments table
INSERT INTO Departments (department_id, department_name, location) VALUES
(1, 'IT', 'Building A'),
(2, 'HR', 'Building B'),
(3, 'Finance', 'Building C');
-- Insert sample data into Employees table
INSERT INTO Employees (employee_id, name, dob, department_id, salary) VALUES
(1, 'Alice Williams', '1985-06-15', 1, 5000.00),
(2, 'Bob Johnson', '1990-03-22', 2, 4500.00),
(3, 'Charlie Brown', '1992-08-10', 1, 5500.00),
(4, 'David Smith', '1988-11-30', NULL, 4700.00);
-- Insert sample data into Projects table
INSERT INTO Projects (project_id, project_name, start_date, end_date) VALUES
(1, 'Project A', '2025-01-01', '2025-12-31'),
(2, 'Project B', '2025-02-01', '2025-11-30');
-- Insert sample data into WorkReports table
INSERT INTO WorkReports (report_id, employee_id, report_date, report_content) VALUES
(1, 1, '2025-01-31', 'Completed initial setup for Project A.'),
(2, 2, '2025-02-10', 'Completed HR review for Project A.'),
(3, 3, '2025-01-20', 'Worked on debugging and testing for Project A.'),
(4, 4, '2025-02-05', 'Worked on financial reports for Project B.'),
(5, NULL, '2025-02-15', 'No report submitted.');
-- Insert sample data into Timesheets table
INSERT INTO Timesheets (timesheet_id, employee_id, project_id, work_date, hours_worked) VALUES
(1, 1, 1, '2025-01-10', 8),
(2, 1, 2, '2025-02-12', 7),
(3, 2, 1, '2025-01-15', 6),
(4, 3, 1, '2025-01-20', 8),
(5, 4, 2, '2025-02-05', 5);


-- Hiển thị thông tin của tất cả các nhân viên
select * from employees;
-- Hiển thị thông tin của tất cả các dự án
select * from projects;

-- Lấy tên nhân viên và tên phòng ban mà họ đang làm việc.
select e.name, d.department_name
from employees e
join departments d on e.department_id = d.department_id;

-- Lấy tên nhân viên và nội dung báo cáo công việc của họ.
select e.name, wr.report_content
from employees e
join work_reports wr on e.employee_id = wr.employee_id;

-- Lấy tên nhân viên, tên dự án và số giờ làm việc cho mỗi dự án.
select e.name, p.project_name, t.hours_worked
from timesheets t
join employees e on t.employee_id = e.employee_id
join projects p on t.project_id = p.project_id;

-- Lấy tên nhân viên và số giờ làm việc của họ cho dự án "Project A".
select e.name, t.hours_worked
from timesheets t
join employees e on t.employee_id = e.employee_id
join projects p on t.project_id = p.project_id
where p.project_name = 'Project A';

    
-- Thực hiện cập nhật, sửa, xóa theo các yêu cầu sau
-- Cập nhật lương của các nhân viên có tên chứa từ "Alice" (ví dụ: Alice Williams) thành 6500.00.
update employees
set salary = 6500.00
where name like '%Alice%';
-- Xóa tất cả báo cáo công việc của nhân viên có tên chứa từ "Brown" .
delete from work_reports
where employee_id in (
    select employee_id from employees where name like '%Brown%'
);
-- Thêm một nhân viên mới có tên "James Lee", ngày sinh "1996-05-20", vào phòng ban "IT" (department_id = 1) với lương 5000.00.
insert into employees (employee_id, name, dob, department_id, salary)
values (5, 'James Lee', '1996-05-20', 1, 5000.00);