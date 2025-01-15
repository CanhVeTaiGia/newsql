create database ss2;

use ss2;
create table staff(
	staff_id int primary key auto_increment,
    staff_name varchar(50) not null,
    starting_date date,
    salary decimal(10,2) default(5000)
);

insert into staff (staff_id, staff_name, starting_date, salary) values
(1, 'Trần Văn A', '2024-01-01', 10000),
(2, 'Nguyễn Thị B', '2024-02-15', 12000	),
(3, 'Lê Văn C', '2024-03-10', 9000);

update staff
set salary = 7000
where staff_id = 1;

delete from staff
where staff_id = 3;