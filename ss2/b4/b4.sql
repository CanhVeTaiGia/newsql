create database ss2;

use ss2;
create table staff(
	staff_id int primary key,
    staff_name varchar(50) not null,
    starting_date date,
    salary decimal default(5000)
)