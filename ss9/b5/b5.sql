use classicmodels;
--  Tạo index có tên idx_creaditLimit trên cột creditLimit của bảng customers.
create index idx_creaditLimit on customers(creditLimit);
--  3) Thực hiện truy vấn với các yêu cầu 
select c.customerNumber, c.customerName, c.city, c.creditLimit from customers c
left join offices o on c.salesRepEmployeeNumber = o.officeCode
where c.creditLimit between 50000 and 100000
order by c.creditLimit desc
limit 5;
--  4) Sử dụng EXPLAIN ANALYZE để kiểm tra lại kế hoạch thực thi trước và sau khi có chỉ mục.
EXPLAIN ANALYZE select c.customerNumber, c.customerName, c.city, c.creditLimit from customers c
left join offices o on c.salesRepEmployeeNumber = o.officeCode
where c.creditLimit between 50000 and 100000
order by c.creditLimit desc
limit 5;