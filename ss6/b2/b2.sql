-- 2
select CustomerName,ProductName,sum(Quantity) as TotalQuantity from Orders
group by CustomerName,ProductName
having sum(Quantity) > 1;

-- 3
select CustomerName,OrderDate,Quantity from Orders
where Quantity > 2;

-- 4
select CustomerName,OrderDate,Quantity*Price as TotalSpent from Orders
where Quantity*Price > 20000000;
