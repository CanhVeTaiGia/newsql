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
delimiter &&
create procedure register_course(
    in p_student_name varchar(50),
    in p_course_name varchar(100)
)
begin
    declare v_student_id int;
    declare v_course_id int;
    declare v_available_seats int;
    start transaction;
    select student_id into v_student_id from students where student_name = p_student_name limit 1;
    if v_student_id is null then
        signal sqlstate '45000' set message_text = 'Không tìm thấy học sinh';
    end if;
    select course_id, available_seats into v_course_id, v_available_seats 
    from courses 
    where course_name = p_course_name limit 1;
    if v_course_id is null then
        signal sqlstate '45000' set message_text = 'Không tìm thấy môn học';
    end if;
    if v_available_seats > 0 then
        insert into enrollments (student_id, course_id) values (v_student_id, v_course_id);
        update courses set available_seats = available_seats - 1 where course_id = v_course_id;
        commit;
    else
        rollback;
        signal sqlstate '45000' set message_text = 'không còn chỗ ngồi';
    end if;
end &&
delimiter ;

-- 3
call register_course('Nguyễn Văn An', 'Lập trình C');
