use ss11;

-- 2
create view view_high_value_customers 
as
select c.customerid, concat(c.firstname, ' ', c.lastname) as fullname, c.email, sum(i.total) as total_spending
from customer c
join invoice i on c.customerid = i.customerid
where i.invoicedate >= '2010-01-01'
group by c.customerid, fullname, c.email
having sum(i.total) > 200 and c.country != 'brazil';      
  
-- 3
create view view_popular_tracks 
as
select t.trackid, t.name as track_name, sum(il.quantity) as total_sales
from track t
join invoiceline il on t.trackid = il.trackid
where il.unitprice > 1.00 
group by t.trackid, track_name
having sum(il.quantity) > 15;

-- 4
create index idx_customer_country on Customer(Country);

select * from customer where country = 'canada';
explain select * from customer where country = 'canada';

-- 5
alter table track add fulltext index idx_track_name_ft (name);

select * from track where match (name) against ('love');
explain select * from track where match (name) against ('love');

-- 6
select v.customerid, v.fullname, v.email, v.total_spending, c.country
from view_high_value_customers v
join customer c on v.customerid = c.customerid
where c.country = 'canada';
explain select v.customerid, v.fullname, v.email, v.total_spending, c.country
from view_high_value_customers v
join customer c on v.customerid = c.customerid
where c.country = 'canada';

-- 7
select v.trackid, v.track_name, v.total_sales, t.unitprice
from view_popular_tracks v
join track t on v.trackid = t.trackid
where match (t.name) against ('love');

explain select v.trackid, v.track_name, v.total_sales, t.unitprice
from view_popular_tracks v
join track t on v.trackid = t.trackid
where match (t.name) against ('love');

-- 8
delimiter &&
create procedure get_high_value_customers_by_country (in p_country varchar(255))
begin
    select v.customerid, v.fullname, v.email, v.total_spending, c.country
    from view_high_value_customers v
    join customer c on v.customerid = c.customerid
    where c.country = p_country; 
end &&
delimiter ;

-- 9
delimiter &&
create procedure update_customer_spending (in p_customerid int, in p_amount decimal(10,2))
begin
    update invoice
    set total = total + p_amount
    where customerid = p_customerid
    order by invoicedate desc;
end &&
delimiter ;

call update_customer_spending(5, 50.00);

select * from view_high_value_customers where customerid = 5;

-- 10
drop view if exists view_high_value_customers;
drop view if exists view_popular_tracks;
drop index idx_customer_country on customer;
drop index idx_track_name_ft on track;
drop procedure if exists get_high_value_customers_by_country;
drop procedure if exists update_customer_spending;