-- B2
-- 1
use ss9;

-- 2
create view view_manager_summary as select e.manager_id, count(e.employee_id) as total_employees
from employees e
group by e.manager_id;

-- 3
select * from view_manager_summary;

-- 4 
select e.name "manager_name", v.total_employees
from employees e 
join view_manager_summary v
on v.manager_id = e.employee_id;
