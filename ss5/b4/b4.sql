-- Sử dụng lại CSDL ss5 để thực hành lại bài này 
use ss5;
-- Tạo bảng products
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY, 
    product_name VARCHAR(100) NOT NULL,        
    category VARCHAR(50) NOT NULL,            
    price DECIMAL(10, 2) NOT NULL,            
    stock_quantity INT NOT NULL               
);

-- Thêm bản ghi vào products
INSERT INTO products (product_name, category, price, stock_quantity)
VALUES
('Laptop Dell XPS 13', 'Electronics', 25999.99, 10),
('Nike Air Max 270', 'Footwear', 4999.00, 50),
('Samsung Galaxy S22', 'Electronics', 19999.99, 25),
('T-Shirt Uniqlo', 'Clothing', 299.99, 100),
('Apple AirPods Pro', 'Accessories', 5999.00, 15),
('T-Shirt Apolo', 'Clothing', 199.99, 100);

-- B4
-- 2
select 
    p.product_name, 
    p.category, 
    p.price, 
    p.stock_quantity,
    MAX(p.price) over (partition by p.category) as max_price
from products p;

-- 3
select product_name, category, price, stock_quantity
from products
limit 2 offset 2;

-- 4
select product_name, category, price, stock_quantity
from products
where category = 'electronics'
order by price desc;

-- 5
select product_name, category, price, stock_quantity
from products
where category = 'clothing'
order by price asc
limit 1;
