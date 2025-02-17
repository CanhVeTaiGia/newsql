drop database if exists ss13;
create database ss13;
use ss13;

-- 1
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    student_name VARCHAR(50)
);

CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100),
    available_seats INT NOT NULL
);

CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
INSERT INTO students (student_name) VALUES ('Nguyễn Văn An'), ('Trần Thị Ba');

INSERT INTO courses (course_name, available_seats) VALUES 
('Lập trình C', 25), 
('Cơ sở dữ liệu', 22);

-- 2
create table enrollments_history (
	history_id int auto_increment primary key,
    student_id int not null,
    course_id int not null,
    foreign key (student_id) references students(student_id),
    foreign key (course_id) references courses(course_id),
    action varchar(50),
    timestamp datetime default(current_date)
);

-- 3
set autocommit = 0;
delimiter &&

create procedure register_course(
    in p_student_name varchar(50),
    in p_course_name varchar(100)
)
begin
    declare v_student_id int default null;
    declare v_course_id int default null;
    declare v_available_seats int default 0;
    declare v_enrolled int default 0;
    start transaction;
    select student_id into v_student_id 
    from students 
    where lower(student_name) = lower(p_student_name) 
    limit 1;
    select course_id, available_seats into v_course_id, v_available_seats 
    from courses 
    where lower(course_name) = lower(p_course_name) 
    limit 1;
    if v_student_id is null or v_course_id is null then
        insert into enrollments_history (student_id, course_id, action) 
        values (ifnull(v_student_id, 0), ifnull(v_course_id, 0), 'Không thành công - học viên hoặc khóa học không hợp lệ');
        rollback;
    else
        select count(*) into v_enrolled 
        from enrollments 
        where student_id = v_student_id and course_id = v_course_id;
        if v_enrolled > 0 then
            insert into enrollments_history (student_id, course_id, action) 
            values (v_student_id, v_course_id, 'không thành công - đã đăng ký');
            rollback;
        else
            if v_available_seats > 0 then
                insert into enrollments (student_id, course_id) values (v_student_id, v_course_id);
                update courses set available_seats = available_seats - 1 where course_id = v_course_id;
                insert into enrollments_history (student_id, course_id, action) values (v_student_id, v_course_id, 'registered');
                commit;
            else
                insert into enrollments_history (student_id, course_id, action) 
                values (v_student_id, v_course_id, 'Thất bại - hết chỗ ngồi');
                rollback;
            end if;
        end if;
    end if;
end &&
delimiter ;

-- 4
call register_course('Nguyễn Văn An', 'Lập trình C');

-- 5
select * from enrollments;
select * from courses;
select * from enrollments_history;