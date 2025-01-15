create database ss2;

use ss2;
create table product(
	product_id int primary key,
    product_name varchar(30) not null unique,
    product_price decimal(7, 2) not null,
    product_stock int check(product_stock > 0)
)