USE ss12;

-- 2) Tạo bảng deleted_orders để lưu thông tin các đơn hàng đã bị xó
create table deleted_orders(
	deleted_id int primary key auto_increment,
    order_id int not null,
    customer_name varchar(100) not null,
    product varchar(100) not null,
    order_date date not null,
    deleted_at datetime not null
);
-- 3) Tạo trigger AFTER DELETE để lưu thông tin các đơn hàng bị xóa vào bảng deleted_orders
DELIMITER //
create trigger trig_after_delete_orders 
after delete on orders for each row
begin
	insert into deleted_orders (order_id,customer_name, product, order_date, deleted_at) values
	(old.order_id, old.customer_name, old.product, old.order_date,now());
end
// DELIMITER ;
-- 4) Thực hiện thao tác DELETE:
delete from orders where order_id = 4;
delete from orders where order_id = 5;

-- 5) Hiển thị lại bảng deleted_orders để xem thông tin đơn hàng bị xóa
select * from deleted_orders;
