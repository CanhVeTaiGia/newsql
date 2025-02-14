-- 3
create view view_track_details 
as
select t.trackid, t.name as track_name, a.title as album_title, ar.name as artist_name, t.unitprice from track t
join album a on t.albumid = a.albumid
join artist ar on a.artistid = ar.artistid
where t.unitprice > 0.99;

select * from view_track_details;

-- 4
create view view_customer_invoice 
as
select 
	c.customerid, 
    concat(c.lastname, ' ', c.firstname) as fullname,
    c.email, 
    sum(i.total) as total_spending, 
    concat(e.lastname, ' ', e.firstname) as support_rep
from customer c
join invoice i on c.customerid = i.customerid
join employee e on c.supportrepid = e.employeeid
group by c.customerid
having total_spending > 50;

select * from view_customer_invoice;

-- 4
create view view_top_selling_tracks 
as select 
	t.trackid,
    t.name as track_name,
    g.name as genre_name,
    sum(il.quantity) as total_sales
from track t
join invoiceline il on t.trackid = il.trackid
join genre g on t.genreid = g.genreid
group by t.trackid
having total_sales > 10;

select * from view_top_selling_tracks;

-- 5
create index idx_track_name on track (name);
select * from track where name like '%love%';
explain select * from track where name like '%love%';
-- 6
create index idx_invoice_total on invoice (total);
select * from invoice where total between 20 and 100;
explain select * from invoice where total between 20 and 100;

-- 7
delimiter &&
create procedure get_customer_spending(in customerid int)
begin
    select coalesce(total_spending, 0) as totalspent 
    from view_customer_invoice 
    where customerid = customerid;
end &&
delimiter ;

-- 8
delimiter &&
create procedure search_track_by_keyword(in p_keyword varchar(255))
begin
    select * from track where name like concat('%', p_keyword, '%');
end &&
delimiter ;

call search_track_by_keyword('lo');
-- 9
delimiter &&
create procedure get_top_selling_tracks(in p_minsales int, in p_maxsales int)
begin
    select * from view_top_selling_tracks 
    where total_sales between p_minsales and p_maxsales;
end &&
delimiter ;

-- 10
drop view view_track_details;
drop view view_customer_invoice;
drop view view_top_selling_tracks;
drop index  idx_track_name on track;
drop index idx_invoice_total on invoice;
drop procedure if exists get_customer_spending;
drop procedure if exists search_track_by_keyword;
drop procedure if exists get_top_selling_tracks;