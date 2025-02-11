create database qlbh;
use qlbh;

create table customer (
    cID int primary key,
    Name varchar(25),
    cAge tinyint
);

create table orders (
    oID int primary key,
    cID int,
    oDate datetime,
    oTotalPrice int,
    foreign key (cID) references customer(cID)
);

create table product (
    pID int primary key,
    pName varchar(25),
    pPrice int
);

create table orderdetail (
    oID int,
    pID int,
    odQTY int,
    foreign key (oID) references orders(oID),
    foreign key (pID) references product(pID)
);

insert into customer values
(1, 'Minh Quan', 10),
(2, 'Ngoc Oanh', 20),
(3, 'Hong Ha', 50);

insert into orders values
(1, 1, '2006-03-21', null),
(2, 2, '2006-03-23', null),
(3, 1, '2006-03-16', null);

insert into product values
(1, 'May Giat', 3),
(2, 'Tu Lanh', 5),
(3, 'Dieu Hoa', 7),
(4, 'Quat', 1),
(5, 'Bep Dien', 2);

insert into orderdetail values
(1, 1, 3),
(1, 3, 7),
(1, 4, 2),
(2, 1, 1),
(3, 1, 8),
(2, 5, 4),
(2, 3, 3);

-- 2. Hiển thị thông tin hóa đơn sắp xếp theo ngày mới nhất
select * from orders order by oDate desc;

-- 3. Hiển thị sản phẩm có giá cao nhất
select pName, pPrice from product where pPrice = (select max(pPrice) from product);

-- 4. Danh sách khách hàng và sản phẩm đã mua
select c.Name, p.pName 
from customer c
join orders o on c.cID = o.cID
join orderdetail od on o.oID = od.oID
join product p on od.pID = p.pID;

-- 5. Hiển thị tên khách hàng chưa mua hàng
select Name from customer where cID not in (select cID from orders);

-- 6. Hiển thị chi tiết từng hóa đơn
select o.oID, c.Name, o.oDate, p.pName, od.odQTY, p.pPrice, (od.odQTY * p.pPrice) as TotalPrice
from orders o
join customer c on o.cID = c.cID
join orderdetail od on o.oID = od.oID
join product p on od.pID = p.pID
order by o.oID;

-- 7. Hiển thị mã hóa đơn, ngày bán và tổng giá tiền của từng hóa đơn
select o.oID, o.oDate, sum(od.odQTY * p.pPrice) as TotalPrice
from orders o
join orderdetail od on o.oID = od.oID
join product p on od.pID = p.pID
group by o.oID, o.oDate;

-- 8. Xóa ràng buộc khóa ngoại và khóa chính
alter table orderdetail drop foreign key orderdetail_ibfk_1;
alter table orderdetail drop foreign key orderdetail_ibfk_2;
alter table orders drop foreign key orders_ibfk_1;
drop table customer, orders, product, orderdetail;
