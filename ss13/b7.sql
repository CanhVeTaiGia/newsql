drop database if exists ss13;
create database ss13;
use ss13;

-- 1
CREATE TABLE company_funds (
    fund_id INT PRIMARY KEY AUTO_INCREMENT,
    balance DECIMAL(15,2) NOT NULL -- Số dư quỹ công ty
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(50) NOT NULL,   -- Tên nhân viên
    salary DECIMAL(10,2) NOT NULL    -- Lương nhân viên
);

CREATE TABLE payroll (
    payroll_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,                      -- ID nhân viên (FK)
    salary DECIMAL(10,2) NOT NULL,   -- Lương được nhận
    pay_date DATE NOT NULL,          -- Ngày nhận lương
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

INSERT INTO company_funds (balance) VALUES (50000.00);

INSERT INTO employees (emp_name, salary) VALUES
('Nguyễn Văn An', 5000.00),
('Trần Thị Bốn', 4000.00),
('Lê Văn Cường', 3500.00),
('Hoàng Thị Dung', 4500.00),
('Phạm Văn Em', 3800.00);

-- 2
create table banks(
	bank_id int primary key auto_increment,
    bank_name varchar(255) not null,
	status enum('ACTIVE','ERROR')
);

-- 3
INSERT INTO banks (bank_id, bank_name, status) VALUES 
(1,'VietinBank', 'ACTIVE'),   
(2,'Sacombank', 'ERROR'),    
(3, 'Agribank', 'ACTIVE');   

-- 4
alter table company_funds
add column bank_id int,
add constraint fk_bank_id foreign key(bank_id) references banks(bank_id);
-- 5
UPDATE company_funds SET bank_id = 1 WHERE balance = 50000.00;
INSERT INTO company_funds (balance, bank_id) VALUES (45000.00,2);

-- 6
delimiter &&
	create trigger CheckBankStatus
    before insert on payroll
	for each row
begin
    if (select b.status from banks b join company_funds c on b.bank_id = c.bank_id) = 'ERROR' then 
		signal sqlstate '45000' set message_text = 'Ngân hàng gặp lỗi';
    end if;
end &&
delimiter ;

-- 7
set autocommit = 0; 
delimiter &&
	create procedure TransferSalary(p_emp_id int,fund_id_in int)
begin
	declare com_balance decimal(10,2);
	declare emp_salary decimal(10,2);
    declare exit handler for sqlexception
            begin
				insert into transaction_log(log_message)
				values('Ngân hàng lỗi');
                rollback;
            end;
	START TRANSACTION;
	if(select count(emp_id) from employees where emp_id = emp_id_in) = 0
    or (select count(fund_id) from company_funds where fund_id = fund_id_in ) = 0 then
		insert into transaction_log(log_message)
			values('Mã nhân viên hoặc mã công ty không tồn tại');
		rollback;
	else
		select balance into com_balance from company_funds where fund_id = fund_id_in;
		select salary into emp_salary from employees where emp_id = emp_id_in;
        if com_balance < emp_salary then
			insert into transaction_log(log_message)
				values('Số dư tài khoản công ty không đủ');
			rollback;
        else
			update company_funds
            set balance = balance - emp_salary
            where fund_id = fund_id_in;
            insert into transaction_log(log_message)
			values('Thanh toán lương thành công');
            insert into payroll(emp_id,salary,pay_date)
            values(emp_id_in,emp_salary,curdate());
            update employees
            set last_pay_date = curdate()
            where emp_id = p_emp_id;
            commit;
		end if;
	end if;
end &&
delimiter ;

--  8
call TransferSalary(3,2);