-- 2
select s.student_id,s.name as student_name,s.email,c.course_name,e.enrollment_date from students s
join enrollments e on s.student_id = e.student_id
join courses c on e.course_id = c.course_id
where s.student_id in (select student_id from enrollments group by student_id having count(course_id) > 1)
order by s.student_id, e.enrollment_date;

-- 3
select s.name as student_name,s.email,e.enrollment_date,c.course_name,c.fee from students s
join enrollments e on s.student_id = e.student_id
join courses c on e.course_id = c.course_id
where e.course_id in (select e2.course_id from enrollments e2 join students s2 on e2.student_id = s2.student_id where s2.name = 'Nguyen Van An')
and s.name <> 'Nguyen Van An'
order by c.course_name, e.enrollment_date;

-- 4
select c.course_name,c.duration,c.fee,count(e.student_id) as total_students from courses c
join enrollments e on c.course_id = e.course_id
group by c.course_id, c.course_name, c.duration, c.fee
having total_students > 2;

-- 5
select s.name as student_name,s.email,sum(c.fee) as total_fee_paid,count(e.course_id) as courses_count from students s
join enrollments e on s.student_id = e.student_id
join courses c on e.course_id = c.course_id
group by s.student_id, s.name, s.email
having courses_count >= 2 
and min(c.duration) > 30;

