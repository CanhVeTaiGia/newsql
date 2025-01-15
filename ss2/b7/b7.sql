create table order_detail(
	cus_id int,
    order_id int,
    foreign key (cus_id) references customers(cus_id),
    foreign key (order_id) references orders(order_id),
    primary key (cus_id, order_id),
    quantity int not null
);