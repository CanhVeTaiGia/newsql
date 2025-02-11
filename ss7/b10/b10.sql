create database test2;
use test2;

create table students (
    studentid int primary key,
    studentname varchar(100),
    age int,
    email varchar(100)
);

create table class (
    classid int primary key,
    classname varchar(50)
);

create table classstudent (
    studentid int,
    classid int,
    foreign key (studentid) references students(studentid),
    foreign key (classid) references class(classid)
);

create table subjects (
    subjectid int primary key,
    subjectname varchar(50)
);

create table mark (
    mark int,
    subjectid int,
    studentid int,
    foreign key (subjectid) references subjects(subjectid),
    foreign key (studentid) references students(studentid)
);

insert into students (studentid, studentname, age, email) values
(1, 'nguyen quang an', 18, 'an@yahoo.com'),
(2, 'nguyen cong vinh', 20, 'vinh@gmail.com'),
(3, 'nguyen van quyen', 19, 'quyen'),
(4, 'pham thanh binh', 25, 'binh@com'),
(5, 'nguyen van tai em', 30, 'taiem@sport.vn');

insert into class (classid, classname) values
(1, 'c0706l'),
(2, 'c0708g');

insert into classstudent (studentid, classid) values
(1, 1), (2, 1), (3, 2), (4, 2), (5, 2), (5, 1);

insert into subjects (subjectid, subjectname) values
(1, 'sql'),
(2, 'java'),
(3, 'c'),
(4, 'visual basic');

insert into mark (mark, subjectid, studentid) values
(8, 1, 1), (4, 2, 1), (9, 1, 1),
(7, 1, 3), (3, 1, 4), (5, 2, 5),
(8, 3, 3), (1, 3, 5), (3, 2, 4);

-- hiển thị danh sách tất cả học viên
select * from students;

-- hiển thị danh sách tất cả các môn học
select * from subjects;

-- tính điểm trung bình của từng học sinh
select studentid, avg(mark) as avg_mark from mark group by studentid;

-- hiển thị môn học có học sinh thi được trên 9 điểm
select distinct s.subjectname from mark m
join subjects s on m.subjectid = s.subjectid
where m.mark > 9;

-- hiển thị điểm trung bình của từng học sinh theo chiều giảm dần
select studentid, avg(mark) as avg_mark from mark group by studentid order by avg_mark desc;

-- cập nhật thêm dòng chữ “day la mon hoc” vào trước các bản ghi trên cột subjectname trong bảng subjects
update subjects set subjectname = concat('day la mon hoc ', subjectname);

-- viết trigger để kiểm tra độ tuổi nhập vào trong bảng students yêu cầu age >15 và age < 50
delimiter //
create trigger check_student_age
before insert on students
for each row
begin
    if new.age <= 15 or new.age >= 50 then
        signal sqlstate '45000'
        set message_text = 'tuổi học sinh phải lớn hơn 15 và nhỏ hơn 50';
    end if;
end //
delimiter ;

-- loại bỏ quan hệ giữa tất cả các bảng (xóa ràng buộc khóa ngoại)
alter table classstudent drop foreign key classstudent_ibfk_1;
alter table classstudent drop foreign key classstudent_ibfk_2;
alter table mark drop foreign key mark_ibfk_1;
alter table mark drop foreign key mark_ibfk_2;

-- xóa học viên có studentid = 1
delete from students where studentid = 1;

-- trong bảng students thêm một cột status có kiểu dữ liệu là bit và có gía trị default là 1
alter table students add column status bit default 1;

-- cập nhật giá trị status trong bảng students thành 0
update students set status = 0;
