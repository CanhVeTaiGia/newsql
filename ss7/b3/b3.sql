-- Inserting categories of books into the Categories table
INSERT INTO Categories (category_id, category_name) VALUES
(1, 'Science'),
(2, 'Literature'),
(3, 'History'),
(4, 'Technology'),
(5, 'Psychology');

-- Inserting books into the Books table with details such as title, author, and category
INSERT INTO Books (book_id, title, author, publication_year, available_quantity, category_id) VALUES
(1, 'The History of Vietnam', 'John Smith', 2001, 10, 1),
(2, 'Python Programming', 'Jane Doe', 2020, 5, 4),
(3, 'Famous Writers', 'Emily Johnson', 2018, 7, 2),
(4, 'Machine Learning Basics', 'Michael Brown', 2022, 3, 4),
(5, 'Psychology and Behavior', 'Sarah Davis', 2019, 6, 5);

-- Inserting library users (readers) into the Readers table
INSERT INTO Readers (reader_id, name, phone_number, email) VALUES
(1, 'Alice Williams', '123-456-7890', 'alice.williams@email.com'),
(2, 'Bob Johnson', '987-654-3210', 'bob.johnson@email.com'),
(3, 'Charlie Brown', '555-123-4567', 'charlie.brown@email.com');

-- Inserting borrowing records for books
INSERT INTO Borrowing (borrow_id, reader_id, book_id, borrow_date, due_date) VALUES
(1, 1, 1, '2025-02-19', '2025-02-15'),
(2, 2, 2, '2025-02-03', '2025-02-17'),
(3, 3, 3, '2025-02-02', '2025-02-16'),
(4, 1, 2, '2025-03-10', '2025-02-24'),
(5, 2, 3, '2025-05-11', '2025-02-25'),
(6, 2, 3, '2025-02-11', '2025-02-25');


-- Inserting book return records into the Returning table
INSERT INTO Returning (return_id, borrow_id, return_date) VALUES
(1, 1, '2025-03-14'),
(2, 2, '2025-02-28'),
(3, 3, '2025-02-15'),
(4, 4, '2025-02-20'),  
(5, 4, '2025-02-20');

-- Inserting penalty records into the Fines table for late returns
INSERT INTO Fines (fine_id, return_id, fine_amount) VALUES
(1, 1, 5.00),
(2, 2, 0.00),
(3, 3, 2.00);

-- Hiển thị danh sách tất cả các sách
select * from books;
-- Hiển thị danh sách tất cả độc giả
select * from readers;
-- Viết câu truy vấn để lấy thông tin về các bạn đọc và các sách mà họ đã mượn, bao gồm tên bạn đọc, tên sách và ngày mượn.
select r.name as reader_name, b.title as book_title, br.borrow_date 
from borrowing br
join readers r on br.readers_id = r.readers_id
join books b on br.book_id = b.book_id;

-- Viết câu truy vấn để lấy thông tin về các sách và thể loại của chúng, bao gồm tên sách, tác giả và tên thể loại
select b.title as book_title, b.author, c.category_name 
from books b
join categories c on b.category_id = c.category_id;

-- Viết câu truy vấn để lấy thông tin về các bạn đọc và các khoản phạt mà họ phải trả, bao gồm tên bạn đọc, số tiền phạt và ngày trả sách.
select r.name as reader_name, f.fine_amount, rt.return_date 
from fines f
join returning rt on f.return_id = rt.return_id
join borrowing br on rt.borrow_id = br.borrow_id
join readers r on br.readers_id = r.readers_id;


-- Thực hiện update, delete, insert theo các yêu cầu sau:
-- Hãy cập nhật số lượng sách còn lại (cột available_quantity) của cuốn sách có book_id = 1 thành 15.
update books 
set available_quantity = 15 
where book_id = 1;
-- Hãy xóa bạn đọc có reader_id = 2 khỏi bảng Readers.
delete from readers 
where readers_id = 2;
/*
Viết câu truy vấn INSERT INTO để thêm lại bạn đọc có reader_id = 2 vào bảng Readers với 
thông tin như sau: reader_id = 2, name = 'Bob Johnson', phone_number = '987-654-3210', email = 'bob.johnson@email.com'
*/
insert into readers (readers_id, name, phone_number, email) 
values (2, 'Bob Johnson', '987-654-3210', 'bob.johnson@email.com');
