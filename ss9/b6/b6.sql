use classicmodels;

-- 2) Tạo một view tên view_orders_summary hiển thị thống kê số đơn hàng của từng khách hàng
create view view_orders_summary
as
select c.customerNumber ,c.customerName ,count(o.customerNumber) as total_orders from customers c
join orders o on c.customerNumber = o.customerNumber
group by o.customerNumber;

select * from view_orders_summary
where total_orders > 3;

