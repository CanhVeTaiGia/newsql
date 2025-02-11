-- Lấy tên nhân viên và phòng ban của họ, sắp xếp theo tên nhân viên.
select e.name, d.department_name
from employees e
join departments d on e.department_id = d.department_id
order by e.name;
-- Lấy tên nhân viên và lương của các nhân viên có lương trên 5000, sắp xếp theo lương giảm dần.
select name, salary
from employees
where salary > 5000
order by salary desc;
-- Lấy tên nhân viên và tổng số giờ làm việc của mỗi nhân viên.
select e.name, coalesce(sum(t.hours_worked), 0) as total_hours
from employees e
left join timesheets t on e.employee_id = t.employee_id
group by e.name;
-- Lấy tên phòng ban và lương trung bình của các nhân viên trong phòng ban đó.
select d.department_name, round(avg(e.salary), 2) as avg_salary
from employees e
join departments d on e.department_id = d.department_id
group by d.department_name;
-- Lấy tên dự án và tổng số giờ làm việc cho mỗi dự án, chỉ tính những báo cáo công việc trong tháng 2 năm 2025.
select p.project_name, sum(t.hours_worked) as total_hours
from timesheets t
join projects p on t.project_id = p.project_id
where t.work_date between '2025-02-01' and '2025-02-28'
group by p.project_name;
-- Lấy tên nhân viên, tên dự án và tổng số giờ làm việc cho mỗi nhân viên trong từng dự án.
select e.name, p.project_name, sum(t.hours_worked) as total_hours
from timesheets t
join employees e on t.employee_id = e.employee_id
join projects p on t.project_id = p.project_id
group by e.name, p.project_name;
-- Lấy tên phòng ban và số lượng nhân viên trong mỗi phòng ban, chỉ lấy các phòng ban có hơn 1 nhân viên.
select d.department_name, count(e.employee_id) as num_employees
from employees e
join departments d on e.department_id = d.department_id
group by d.department_name
having count(e.employee_id) > 1;
-- Lấy thông tin ngày báo cáo, tên nhân viên và nội dung báo cáo của 2 báo cáo, bắt đầu từ bản ghi thứ 2, sắp xếp theo ngày báo cáo giảm dần.
select wr.report_date, e.name, wr.report_content
from work_reports wr
join employees e on wr.employee_id = e.employee_id
order by wr.report_date desc
limit 2 offset 1;
/*Lấy ngày báo cáo, tên nhân viên và số lượng báo cáo được gửi vào mỗi ngày, 
chỉ lấy báo cáo không có giá trị NULL trong nội dung và báo cáo được gửi trong khoảng thời gian từ '2025-01-01' đến '2025-02-01'.
*/
select wr.report_date, e.name, count(wr.report_id) as total_reports
from work_reports wr
join employees e on wr.employee_id = e.employee_id
where wr.report_content is not null 
and wr.report_date between '2025-01-01' and '2025-02-01'
group by wr.report_date, e.name;
/*Lấy thông tin về nhân viên, dự án, giờ làm việc, và số tiền lương của nhân viên (lương = giờ làm việc * mức lương), 
chỉ lấy nhân viên có tổng số giờ làm việc lớn hơn 5, sắp xếp theo tổng lương. Tiền lương được làm tròn
*/
select e.name, p.project_name, sum(t.hours_worked) as total_hours, 
       round(sum(t.hours_worked * (e.salary / 160)), 2) as total_salary
from timesheets t
join employees e on t.employee_id = e.employee_id
join projects p on t.project_id = p.project_id
group by e.name, p.project_name
having sum(t.hours_worked) > 5
order by total_salary desc;