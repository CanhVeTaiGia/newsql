create database StudentTest;
use StudentTest;

create table Test(
	test_id int primary key,
    name varchar(20) 
);

create table StudentTest(
	RN int,
    test_id int,
    primary key(RN,test_id),
    foreign key(RN) references Student(RN),
    foreign key(test_id) references Test(test_id),
    date datetime,
    mark float
);

create table Student(
	RN int primary key,
    Name varchar(20),
    age tinyint
);

insert into student (rn, name, age) values
(1, 'Nguyen Hong Ha', 20),
(2, 'Truong Ngoc Anh', 30),
(3, 'Tuan Minh', 25),
(4, 'Dan Truong', 22);

insert into test (test_id, name) values
(1, 'EPC'),
(2, 'DWMX'),
(3, 'SQL1'),
(4, 'SQL2');

insert into studenttest (rn, test_id, date, mark) values
(1, 1, '2006-07-17', 8),
(1, 2, '2006-07-18', 5),
(1, 3, '2006-07-19', 7),
(2, 1, '2006-07-17', 7),
(2, 2, '2006-07-18', 4),
(2, 3, '2006-07-19', 2),
(3, 1, '2006-07-17', 10),
(3, 3, '2006-07-18', 1);

-- Thêm ràng buộc CHECK cho cột age với giá trị thuộc khoảng 15-55
alter table student 
add constraint chk_age check (age between 15 and 55);

-- Thêm giá trị mặc định cho cột mark trong bảng studenttest là 0
alter table studenttest 
alter column mark set default 0;

-- Thêm khóa chính cho bảng studenttest là (rn, test_id)
alter table studenttest 
drop primary key, 
add primary key (rn, test_id);

-- Thêm ràng buộc unique cho cột name trên bảng test
alter table test 
add constraint unique_test_name unique (name);

-- Xóa ràng buộc unique trên bảng test
alter table test 
drop index unique_test_name;

-- 1. Hiển thị danh sách các học viên đã tham gia thi, các môn thi được thi bởi các học viên đó, điểm thi và ngày thi
select s.rn as student_id,s.name as student_name,t.test_id,t.name as test_name,st.mark,st.date
from studenttest st
join student s on st.rn = s.rn
join test t on st.test_id = t.test_id;

-- 2. Hiển thị danh sách các bạn học viên chưa thi môn nào
select s.rn as student_id, s.name as student_name, s.age
from student s
left join studenttest st on s.rn = st.rn
where st.rn is null;

-- 3. Hiển thị danh sách học viên phải thi lại, tên môn học phải thi lại và điểm thi
select s.rn as student_id,s.name as student_name,t.test_id,t.name as test_name,st.mark
from studenttest st
join student s on st.rn = s.rn
join test t on st.test_id = t.test_id
where st.mark < 5;

-- 4. Hiển thị danh sách học viên và điểm trung bình(Average) của các môn đã thi. Danh sách phải sắp xếp theo thứ tự điểm trung bình giảm dần
select s.rn as student_id,s.name as student_name,avg(st.mark) as average_mark
from studenttest st
join student s on st.rn = s.rn
group by s.rn, s.name
order by average_mark desc;

-- 5. Hiển thị tên và điểm trung bình của học viên có điểm trung bình lớn nhất
select s.name as student_name,avg(st.mark) as average_mark from studenttest st
join student s on st.rn = s.rn
group by s.rn, s.name
having avg(st.mark) = (
    select max(avg_mark)
    from (select avg(mark) as avg_mark from studenttest group by rn) as avg_scores
);

-- 6. Hiển thị điểm thi cao nhất của từng môn học. Danh sách phải được sắp xếp theo tên môn học
select t.name as test_name,max(st.mark) as highest_mark from studenttest st
join test t on st.test_id = t.test_id
group by t.test_id, t.name
order by t.name;

-- 7. Hiển thị danh sách tất cả các học viên và môn học mà các học viên đó đã thi nếu học viên chưa thi môn nào thì phần tên môn học để Null
select s.rn as student_id,s.name as student_name,t.name as test_name,st.mark,st.date from student s
left join studenttest st on s.rn = st.rn
left join test t on st.test_id = t.test_id
order by s.rn, t.name;

-- 8. Sửa (Update) tuổi của tất cả các học viên mỗi người lên một tuổi.
update student
set age = age + 1;
-- Thêm trường tên là Status có kiểu Varchar(10) vào bảng Student.
alter table student
add column status varchar(10);

-- 9. Cập nhật(Update) trường Status sao cho những học viên nhỏ hơn 
-- 30 tuổi sẽ nhận giá trị ‘Young’, trường hợp còn lại nhận giá trị ‘Old’ sau đó hiển thị toàn bộ nội dung bảng Student 
update student
set status = case 
    when age < 30 then 'Young'
    else 'Old'
end;
select * from student;

-- 10. Hiển thị danh sách học viên và điểm thi, dánh sách phải sắp xếp tăng dần theo ngày thi
select s.rn as student_id,s.name as student_name,t.name as test_name,st.mark,st.date from studenttest st
join student s on st.rn = s.rn
join test t on st.test_id = t.test_id
order by st.date asc;

-- 11. Hiển thị các thông tin sinh viên có tên bắt đầu bằng ký tự ‘T’ và điểm thi trung bình >4.5. Thông tin bao gồm Tên sinh viên, tuổi, điểm trung bình
select s.name as student_name, s.age, avg(st.mark) as avg_mark from student s
join studenttest st on s.rn = st.rn
where s.name like 'T%' 
group by s.rn, s.name, s.age
having avg(st.mark) > 4.5;

-- 12. Hiển thị các thông tin sinh viên (Mã, tên, tuổi, điểm trung bình, xếp hạng). Trong đó, xếp hạng dựa vào điểm trung bình của học viên, điểm trung bình cao nhất thì xếp hạng 1.
select s.rn as student_id,s.name as student_name, s.age,avg(st.mark) as avg_mark,
rank() over (order by avg(st.mark) desc) as ranking
from student s
join studenttest st on s.rn = st.rn
group by s.rn, s.name, s.age
order by ranking;

-- 13. Sủa đổi kiểu dữ liệu cột name trong bảng student thành nvarchar(max)
alter table student 
modify column name nvarchar(255);

-- 14. Cập nhật (sử dụng phương thức write) cột name trong bảng student với yêu cầu sau: Nếu tuổi >20 -> thêm ‘Old’ vào trước tên (cột name)
update student
set name = case 
    when age > 20 then 'Old ' + name
end;

-- 15. Nếu tuổi <=20 thì thêm ‘Young’ vào trước tên (cột name)
update student
set name = case 
    when age <= 20 then 'Young ' + name
end;
-- 16. Xóa tất cả các môn học chưa có bất kỳ sinh viên nào thi
delete from test
where test_id not in (select distinct test_id from studenttest);
-- 17. Xóa thông tin điểm thi của sinh viên có điểm <5. 
delete from studenttest 
where mark < 5;

