-- B3
-- 1
use classicmodels;

-- 2
explain analyze select * from customers c
where c.country = "Germany";

-- 3
create index idx_country on customers(country);

-- 4
explain analyze select * from customers c
where c.country = "Germany";
-- Sau khi gắn index chạy chậm hơn

-- 5
drop index idx_country on customers;