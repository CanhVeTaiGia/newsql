use classicmodels;

--  2) Tạo chỉ mục phức hợp (composite index)
 /*
Tìm tất cả các đơn hàng (orders) trong bảng orders có ngày đặt hàng (orderDate) nằm trong năm 2003 
và trạng thái (status) là Shipped. Trả về mã đơn hàng (orderNumber), ngày đặt hàng (orderDate), và trạng thái đơn hàng (status).
*/
select orderNumber, orderDate, status from orders
where year(orderDate) = 2003;

-- Tạo chỉ mục phức hợp(idx_orderDate_status) trên bảng orders với các cột orderDate và status
create index idx_orderDate_status on orders(orderDate,status);
-- Sử dụng EXPLAIN ANALYZE để kiểm tra lại kế hoạch thực thi của truy vấn trên trước và sau khi đánh chỉ mục.
EXPLAIN ANALYZE select orderNumber, orderDate, status from orders
where year(orderDate) = 2003;

--  3)  Tạo chỉ mục duy nhất(Unique index)
 /*
Tìm tất cả các khách hàng (customers) trong bảng customers có số điện thoại (phone) là 2035552570. 
Trả về mã khách hàng (customerNumber), tên khách hàng (customerName), và số điện thoại (phone).
*/
select customerNumber,customerName,phone from customers where phone = '2035552570';
-- Tạo chỉ mục duy nhất (idx_customerNumber) trên cột customerNumber trong bảng customers.
create unique index idx_customerNumber on customers(customerNumber);
-- Tạo chỉ mục duy nhất (idx_phone) trên cột phone trong bảng customers
create unique index idx_phone on customers(phone);
-- Sử dụng EXPLAIN ANALYZE để kiểm tra lại kế hoạch thực thi của truy vấn trên trước và sau khi tạo 2 chỉ mục
 EXPLAIN ANALYZE select customerNumber,customerName,phone from customers where phone = '2035552570';
 
 --  4) Thực hiện xóa các chỉ mục
drop index idx_orderDate_status on orders;
  
drop index idx_customerNumber on customers;
   
drop index idx_order on customers;