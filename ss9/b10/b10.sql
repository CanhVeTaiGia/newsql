use classicmodels;

--  2) Tạo một index trên cột productLine của bảng products
create index idx_pro_line on products(productLine);

-- 3) Tạo một view có tên view_total_sales thống kê tổng số tiền bán hàng (total_sales ) 
-- và tổng số  lượng đã bán (total_quantity) theo từng dòng sản phẩm (productLine). Cột total_sales - tổng tiền bán hàng

create view view_total_sales
as 
select p.productLine,sum(o.quantityOrdered * o.priceEach) as total_sales ,sum(o.quantityOrdered) as total_quantity 
from products p
join orderdetails o on p.productCode = o.productCode
group by p.productLine;
--  5) Thực hành truy vấn theo các mô tả sau : 
select p.productLine,p.textDescription,v.total_sales,v.total_quantity,
    case 
        when length(p.textDescription) > 30 
        then concat(left(p.textDescription, 30), '...') 
        else p.textDescription 
    end as description_snippet,
    case 
        when v.total_quantity > 1000 then v.total_sales / v.total_quantity * 1.1
        when v.total_quantity between 500 and 1000 then v.total_sales / v.total_quantity
        else v.total_sales / v.total_quantity * 0.9
    end as sales_per_product
from view_total_sales v
join productlines p on v.productLine = p.productLine
where v.total_sales > 2000000
order by v.total_sales desc;


