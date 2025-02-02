create database student_manager;
use student_manager;

-- Bài 1
select student_id, last_name, first_name, scholarship 
from students 
order by student_id asc;

-- Bài 2
select student_id, concat(last_name, ' ', first_name) as full_name, gender, birth_date 
from students 
order by gender asc;

-- Bài 3
select concat(last_name, ' ', first_name) as full_name, birth_date, scholarship 
from students 
order by birth_date asc, scholarship desc;

-- Bài 4
select subject_id, subject_name, lesson_count 
from subjects 
where subject_name like 't%';

-- Bài 5
select concat(last_name, ' ', first_name) as full_name, birth_date, gender 
from students 
where first_name like '%i';

-- Bài 6
select faculty_id, faculty_name 
from faculties 
where faculty_name like '_n%';

-- Bài 7
select * 
from students 
where last_name like '%thị%';

-- Bài 8
select student_id, concat(last_name, ' ', first_name) as full_name, faculty_id, scholarship 
from students 
where scholarship > 100000 
order by faculty_id desc;

-- Bài 9
select concat(last_name, ' ', first_name) as full_name, faculty_id, birth_place, scholarship 
from students 
where scholarship >= 150000 and birth_place = 'Hà Nội';

-- Bài 10
select student_id, faculty_id, gender 
from students 
where faculty_id in (select faculty_id from faculties where faculty_name in ('english', 'physics'));

-- Bài 11
select student_id, birth_date, birth_place, scholarship 
from students 
where birth_date between '1991-01-01' and '1992-06-05';

-- Bài 12
select student_id, birth_date, gender, faculty_id 
from students 
where scholarship between 80000 and 150000;

-- Bài 13
select * 
from subjects 
where lesson_count > 30 and lesson_count < 45;

-- Bài 14
select student_id, concat(last_name, ' ', first_name) as full_name, faculty_name, gender 
from students 
join faculties on students.faculty_id = faculties.faculty_id 
where gender = 'male' and faculty_name in ('english', 'computer science');

-- Bài 15
select * 
from students 
where gender = 'female' and first_name like '%n%';

-- Bài 16
select last_name, first_name, birth_place, birth_date 
from students 
where birth_place = 'hà nội' and month(birth_date) = 2;

-- Bài 17
select concat(last_name, ' ', first_name) as full_name, year(curdate()) - year(birth_date) as age, scholarship 
from students 
where year(curdate()) - year(birth_date) > 20;

-- Bài 18
select concat(last_name, ' ', first_name) as full_name, year(curdate()) - year(birth_date) as age, faculty_name 
from students 
join faculties on students.faculty_id = faculties.faculty_id 
where year(curdate()) - year(birth_date) between 20 and 25;

-- Bài 19
select concat(last_name, ' ', first_name) as full_name, gender, birth_date 
from students 
where year(birth_date) = 1990 and month(birth_date) in (1, 2, 3);

-- Bài 20
select student_id, gender, faculty_id, 
       case when scholarship > 500000 then 'high scholarship' else 'medium scholarship' end as scholarship_level 
from students;

-- Bài 21
select count(*) as total_students from students;

-- Bài 22
select count(*) as total_students, sum(case when gender = 'female' then 1 else 0 end) as total_female_students from students;

-- Bài 23
select faculty_id, count(*) as student_count 
from students 
group by faculty_id;

-- Bài 24
select subject_id, count(distinct student_id) as student_count 
from results 
group by subject_id;

-- Bài 25
select count(distinct subject_id) as total_subjects 
from results;

-- Bài 26
select faculty_id, sum(scholarship) as total_scholarship 
from students 
group by faculty_id;

-- Bài 27
select faculty_id, max(scholarship) as max_scholarship 
from students 
group by faculty_id;

-- Bài 28
select faculty_id, 
       sum(case when gender = 'male' then 1 else 0 end) as male_students,
       sum(case when gender = 'female' then 1 else 0 end) as female_students
from students 
group by faculty_id;

-- Bài 29
select year(curdate()) - year(birth_date) as age, count(*) as student_count 
from students 
group by age;

-- Bài 30
select birth_year, count(*) as student_count 
from (select year(birth_date) as birth_year from students) as birth_table 
group by birth_year 
having student_count = 2;

-- Bài 31
select birth_place, count(*) as student_count 
from students 
group by birth_place 
having student_count > 2;

-- Bài 32
select subject_id, count(distinct student_id) as student_count 
from results 
group by subject_id 
having student_count > 3;

-- Bài 33
select student_id, count(*) as retake_count 
from results 
where exam_attempt > 2 
group by student_id 
having retake_count > 2;

-- Bài 34
select student_id, avg(score) as average_score 
from results 
where gender = 'male' and exam_attempt = 1 
group by student_id 
having average_score > 7.0;

-- Bài 35
select student_id, count(*) as failed_count 
from results 
where score < 5 and exam_attempt = 1 
group by student_id 
having failed_count > 2;

-- Bài 36
select faculty_id, count(*) as male_count 
from students 
where gender = 'male' 
group by faculty_id 
having male_count > 2;

-- Bài 37
select faculty_id, count(*) as scholarship_count 
from students 
where scholarship between 200000 and 300000 
group by faculty_id 
having scholarship_count = 2;
