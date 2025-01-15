create database ss2;

use ss2;
create table customers(
	cus_id int primary key,
    cus_name varchar(30),
    cus_phone_number varchar(11)
);

create table orders(
	order_id int primary key,
	created_at date,
    cus_id int not null,
    foreign key (cus_id) references customers(cus_id)
)