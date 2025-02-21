-- 2.1
DROP DATABASE IF EXISTS shopping_managerment;
CREATE DATABASE shopping_managerment;
USE shopping_managerment;

CREATE TABLE customers(
    cus_id INT AUTO_INCREMENT PRIMARY KEY,
    cus_name VARCHAR(100) NOT NULL,
    cus_phone VARCHAR(20) NOT NULL,
    address VARCHAR(255) 
);

-- 2.2
CREATE TABLE products(
    pro_id INT AUTO_INCREMENT PRIMARY KEY,
    pro_name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL CHECK(quantity >= 0),
    category VARCHAR(50) NOT NULL
);

CREATE TABLE employees(
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    emp_birthdate DATE,
    emp_position VARCHAR(50) NOT NULL
);

CREATE TABLE orders(
    or_id INT AUTO_INCREMENT PRIMARY KEY,
    cus_id INT NOT NULL,
    emp_id INT NOT NULL,
    or_date DATETIME,
    total_amount DECIMAL(10, 2),
    Foreign Key (cus_id) REFERENCES customers(cus_id), 
    Foreign Key (emp_id) REFERENCES employees(emp_id)
);

CREATE TABLE order_details(
    ord_id INT AUTO_INCREMENT PRIMARY KEY,
    or_id INT NOT NULL,
    pro_id INT NOT NULL,
    quantity INT check(quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL,
    Foreign Key (or_id) REFERENCES orders(or_id),
    Foreign Key (pro_id) REFERENCES products(pro_id)
);

-- 3.1
ALTER TABLE customers
    ADD COLUMN cus_email VARCHAR(100) NOT NULL UNIQUE;

-- 3.2
ALTER TABLE employees
    DROP COLUMN emp_birthdate;

-- 4
INSERT INTO customers (cus_name, cus_phone, address, cus_email) VALUES
('Nguyen Van A', '0123456789', 'Ha Noi', 'a@gmail.com'),
('Tran Thi B', '0987654321', 'Ho Chi Minh', 'b@gmail.com'),
('Le Van C', '0111222333', 'Da Nang', 'c@gmail.com'),
('Pham Thi D', '0999888777', 'Hai Phong', 'd@gmail.com'),
('Hoang Van E', '0888777666', 'Can Tho', 'e@gmail.com');

INSERT INTO products (pro_name, price, quantity, category) VALUES
('Laptop Dell', 1500.00, 10, 'Electronics'),
('iPhone 14', 1200.00, 15, 'Electronics'),
('Bàn phím cơ', 80.00, 30, 'Accessories'),
('Chuột gaming', 50.00, 40, 'Accessories'),
('Tủ lạnh Samsung', 500.00, 5, 'Appliances');

INSERT INTO employees (emp_name, emp_position) VALUES
('Nguyen Van X', 'Sales Manager'),
('Tran Van Y', 'Cashier'),
('Le Thi Z', 'Store Assistant'),
('Pham Van M', 'Warehouse Staff'),
('Hoang Thi N', 'Customer Service');

INSERT INTO orders (cus_id, emp_id, or_date, total_amount) VALUES
(1, 2, '2025-02-01 10:30:00', 150.75),
(2, 3, '2025-02-02 11:00:00', 220.50),
(3, 1, '2025-02-03 12:15:00', 99.99),
(4, 5, '2025-02-04 14:20:00', 305.00),
(5, 4, '2025-02-05 16:45:00', 180.25);

INSERT INTO order_details (or_id, pro_id, quantity, unit_price) VALUES
(1, 1, 1, 1500.00),
(2, 2, 2, 1200.00),
(3, 3, 1, 80.00),
(4, 4, 3, 50.00),
(5, 5, 1, 500.00);

-- 5
-- 5.1
SELECT c.cus_id, c.cus_name, c.cus_email, c.cus_phone, c.cus_phone, c.address FROM customers c;

-- 5.2
UPDATE products
    SET pro_name = "Laptop Dell XPS", price = 99.99
    WHERE pro_id = 1;


-- 5.3
SELECT o.cus_id, c.cus_name, o.total_amount, o.or_date FROM orders o
JOIN customers c ;

-- 6
-- 6.1
SELECT c.cus_id, c.cus_name, count(o.or_id) "total_ordered" FROM customers c
JOIN orders o
GROUP BY c.cus_id;

-- 6.2
SELECT c.cus_id, c.cus_name, SUM(o.total_amount) FROM orders o
JOIN customers c
WHERE (select YEAR(o.or_date)) = (select YEAR(CURRENT_DATE))
GROUP BY c.cus_id;

-- 6.3
SELECT 
    p.pro_id, 
    p.pro_name, 
    COUNT(o.ord_id) AS total_orders,
    SUM(CASE WHEN o.quantity < 100 THEN 1 ELSE 0 END) AS low_quantity_orders
FROM products p
JOIN order_details o ON o.pro_id = p.pro_id
GROUP BY p.pro_id, p.pro_name
ORDER BY p.pro_name DESC;

-- 7
-- 7.1
SELECT c.cus_id, c.cus_name FROM customers c
LEFT JOIN orders o on c.cus_id = o.or_id
WHERE o.or_id IS NULL; 

-- 7.2
SELECT p.pro_id, p.pro_name, p.price, p.category, p.quantity FROM products p
WHERE p.price > (select AVG(p.price) from products p);

-- 7.3
SELECT o.cus_id, c.cus_name, SUM(o.total_amount) AS total_spent
FROM orders o
JOIN customers c ON o.cus_id = c.cus_id
GROUP BY o.cus_id, c.cus_name
HAVING SUM(o.total_amount) = (
    SELECT MAX(total_spent)
    FROM (
        SELECT SUM(o.total_amount) AS total_spent
        FROM orders o
        GROUP BY o.cus_id
    ) AS subquery
);

-- 8
-- 8.1
CREATE VIEW view_order_list AS SELECT
o.or_id, c.cus_name, e.emp_name, o.total_amount, o.or_date
FROM orders o
JOIN customers c
JOIN employees e;

-- 8.2
CREATE VIEW view_order_detail_product AS SELECT
od.ord_id, p.pro_name, od.quantity, od.unit_price
FROM order_details od
JOIN products p

-- 9
-- 9.1
DELIMITER &&
create procedure proc_insert_employee(
    in p_employee_name varchar(100),
    in p_position varchar(50),
    in p_salary decimal(10, 2)
) 
begin
    insert into Employees (employee_name, position, salary) value (p_employee_name, p_position, p_salary);
    set @last_id = LAST_INSERT_ID();
end &&
DELIMITER ;

-- 9.2
DELIMITER &&
create procedure proc_get_orderdetails(
    in p_order_id int,
    out o_order_detail_ids varchar(255),
    out o_product_names varchar(255),
    out o_quantities varchar(255),
    out o_unit_prices varchar(255)
) 
begin
    set @o_order_detail_ids = '';
    set @o_product_names = '';
    set @o_quantities = '';
    set @o_unit_prices = '';

    select GROUP_CONCAT(od.order_detail_id), GROUP_CONCAT(p.product_name), GROUP_CONCAT(od.quantity), GROUP_CONCAT(od.unit_price) 
    into @o_order_detail_ids, @o_product_names, @o_quantities, @o_unit_prices
    from OrderDetails od join Products p on od.product_id = p.product_id where od.order_id = p_order_id;
end &&
DELIMITER ;

-- 9.3
DELIMITER &&
create procedure proc_cal_total_amount_by_order(
    in p_order_id int,
    out o_total_amount decimal(10, 2)
) 
begin
    select SUM(od.unit_price * od.quantity) into o_total_amount 
    from OrderDetails od where od.order_id = p_order_id;
end &&
DELIMITER ;

-- 10
DELIMITER &&
create trigger trigger_after_insert_order_details 
before insert on OrderDetails for each row
begin
    declare v_quantity_available int;

    select quantity into v_quantity_available from Products where product_id = new.product_id;
    if v_quantity_available < new.quantity then
        signal sqlstate '45000' set message_text = 'Số lượng sản phẩm trong kho không đủ';
        rollback;
    end if;
end &&
DELIMITER ;

-- 11
DELIMITER &&
create procedure proc_insert_order_details(
    in p_order_id int,
    in p_product_id int,
    in p_quantity int,
    in p_unit_price decimal(10,2)
) 
begin
    declare exit handler for sqlexception
    begin
        rollback;
    end;

    start transaction;

    if not exists (select 1 from Orders where order_id = p_order_id) then
        signal sqlstate '45001' set message_text = 'Không tồn tại mã hóa đơn';
    else
        insert into OrderDetails(order_id, product_id, quantity, unit_price)
        values(p_order_id, p_product_id, p_quantity, p_unit_price);

        update Orders 
        set total_amount = total_amount + (p_quantity * p_unit_price) 
        where order_id = p_order_id;

        commit;
    end if;
end &&
DELIMITER ;