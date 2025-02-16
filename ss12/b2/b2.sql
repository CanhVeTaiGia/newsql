USE ss12;
-- 2) Tiến hành tạo bảng theo yêu cầu dưới đây
create table price_changes(
	change_id int primary key auto_increment,
    product varchar(100) not null,
    old_price decimal(10,2) not null,
    new_price decimal(10,2) not null
);

DELIMITER //
create trigger after_update_order 
after update on orders
for each row
begin
	insert into price_changes(product, old_price, new_price)	
    value(new.product,old.price,new.price);
end //
DELIMITER ;	
-- 4) Thực hiện thao tác UPDATE:
update orders 
set price =  1400.00
where product = 'Laptop';
update orders
set price = 800.00 
where product = 'Smartphone';
 --  5) Kiểm tra lại dữ liệu trong bảng price_changes
 select * from price_changes;

 
