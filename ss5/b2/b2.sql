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

-- B2
-- 2
select p.product_id, p.product_name, p.price, p.price + (p.price * 0.10) as new_price
from products p;

-- 3
select p.product_id, p.product_name, p.price, p.stock_quantity
from products p
where p.price < 10000 and p.stock_quantity > 20;

-- 4
select p.product_id, p.product_name, p.price, p.stock_quantity, p.price * p.stock_quantity as total_stock_value
from products p;

-- 5
select p.product_id, p.product_name, p.category, p.price
from products p
where category = "Electronics" and p.price > 20000;