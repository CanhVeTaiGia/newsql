create database ss7;
use ss7;

create table categories(
	category_id int primary key,
    category_name varchar(255) not null
);

create table books(
	book_id int primary key,
    title varchar(255) not null,
    author varchar(255) not null,
    publication_year int,
    available_quantity int,
    category_id int,
    foreign key(category_id) references categories(category_id)
);

create table readers(
	readers_id int primary key,
    name varchar(255) not null,
    phone_number varchar(15) unique,
    email varchar(255) unique
);

create table borrowing(
	borrow_id int primary key,
    readers_id int not null,
    book_id int not null,
    foreign key(readers_id) references readers(readers_id),
    foreign key(book_id) references books(book_id),
    borrow_date date,
    due_date date
); 

create table returning(
	return_id int primary key,
	borrow_id int not null,
    return_date date,
    foreign key(borrow_id) references borrowing(borrow_id)
); 
create table fines(
	fine_id int primary key,
    return_id int not null,
    fine_amount decimal(10,2),
    foreign key(return_id) references returning (return_id)
);

insert into categories (category_id, category_name) 
values(1, 'Fiction'),
(2, 'Science');

insert into books (book_id, title, author, publication_year, available_quantity, category_id) 
values(1, 'The Great Gatsby', 'F. Scott Fitzgerald', 1925, 5, 1),
(2, 'Brief History of Time', 'Stephen Hawking', 1988, 3, 2);

insert into readers (readers_id, name, phone_number, email) 
values(1, 'John Doe', '123456789', 'john@example.com'),
(2, 'Jane Smith', '987654321', 'jane@example.com');

insert into borrowing (borrow_id, readers_id, book_id, borrow_date, due_date) 
values(1, 1, 1, '2025-02-01', '2025-02-15'),
(2, 2, 2, '2025-02-03', '2025-02-17');

insert into returning (return_id, borrow_id, return_date) 
values(1, 1, '2025-02-16'),
(2, 2, '2025-02-18');

insert into fines (fine_id, return_id, fine_amount) 
values(1, 1, 5000.00),
(2, 2, 10000.00);

update readers
set phone_number = '111222333', email = 'newemail@example.com'
where reader_id = 1;

delete from books
where book_id = (select book_id from books order by rand() limit 1);

