drop database if exists ss13;
create database ss13;
use ss13;

-- 1
create table accounts(
	account_id int primary key auto_increment,
    account_name varchar(50) not null,
    balance decimal(10, 2) not null check(balance > 0)
);

-- 2
INSERT INTO accounts (account_name, balance) VALUES 
('Nguyễn Văn An', 1000.00),
('Trần Thị Bảy', 500.00);

-- 3
set autocommit = 0;
delimiter &&
create procedure pro_transfer_money (
    in from_account int,
    in to_account int,
    in amount decimal(10, 2),
    out result_code int
)
begin
    declare from_balance decimal(10,2);
    start transaction;
    set result_code = 0;
    if (
        select count(*) from accounts where account_id = from_account
    ) = 0 or (
        select count(*) from accounts where account_id = to_account
    ) = 0 then
        set result_code = 1;
        rollback;
    else
        select balance into from_balance from accounts 
        where account_id = from_account for update;
        if from_balance < amount then
            set result_code = 2;
            rollback;
        else
            update accounts
            set balance = balance - amount
            where account_id = from_account;
            
            update accounts
            set balance = balance + amount
            where account_id = to_account;
            commit;
        end if;
    end if;
end &&
delimiter ;

-- 4
set @amount = 500;
call pro_transfer_money (1, 2, @amount, @result_code);
select @result_code;
