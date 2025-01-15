/*
	a. 5 kiểu dữ liệu cơ bản thường dùng trong mysql
	- int: Kiểu dữ liệu số nguyên
    - varchar / char: kiểu dữ liệu chuỗi văn bản
    - date: Kiểu dữ liệu ngày tháng
    - decimal: kiểu dữ liệu số thực
    - time: Kiểu dữ liệu ngày tháng
    b. Các kiểu dữ liệu phù hợp cho các cột
    student_id: int
    student_name: varchar(50)
    student_birthdate: date
    average_number: float(2;2)
*/

create table student(
	student_id int,
	student_name varchar(10),
    student_birthdate date,
    average_number float(2, 2)
)