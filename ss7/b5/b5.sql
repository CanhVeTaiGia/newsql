-- Lấy tên sách, tác giả và tên thể loại của sách, sắp xếp theo tên sách
select b.title as book_title, b.author, c.category_name 
from books b
join categories c on b.category_id = c.category_id
order by b.title;
-- Lấy tên bạn đọc và số lượng sách mà mỗi bạn đọc đã mượn.
select r.name as reader_name, count(br.book_id) as books_borrowed
from borrowing br
join readers r on br.readers_id = r.readers_id
group by r.name;
-- Lấy số tiền phạt trung bình mà các bạn đọc phải trả.
select avg(f.fine_amount) as average_fine
from fines f;
-- Lấy tên sách và số lượng có sẵn của các sách có số lượng tồn kho cao nhất.
select title, available_quantity 
from books
where available_quantity = (select max(available_quantity) from books);
-- Lấy tên bạn đọc và số tiền phạt mà họ phải trả, chỉ những bạn đọc có khoản phạt lớn hơn 0.
select r.name as reader_name, f.fine_amount
from fines f
join returning rt on f.return_id = rt.return_id
join borrowing br on rt.borrow_id = br.borrow_id
join readers r on br.readers_id = r.readers_id
where f.fine_amount > 0;
-- Lấy tên sách và số lần mượn của mỗi sách, chỉ sách có số lần mượn nhiều nhất
select b.title as book_title, count(br.book_id) as borrow_count
from borrowing br
join books b on br.book_id = b.book_id
group by b.title
having count(br.book_id) = (
    select max(borrow_count)
    from (select count(book_id) as borrow_count from borrowing group by book_id) as book_borrows
);
-- Lấy tên sách, tên bạn đọc và ngày mượn của các sách chưa trả, sắp xếp theo ngày mượn.
select b.title as book_title, r.name as reader_name, br.borrow_date
from borrowing br
join books b on br.book_id = b.book_id
join readers r on br.readers_id = r.readers_id
left join returning rt on br.borrow_id = rt.borrow_id
where rt.return_id is null
order by br.borrow_date;
-- Lấy tên bạn đọc và tên sách của các bạn đọc đã trả sách đúng hạn
select r.name as reader_name, b.title as book_title
from borrowing br
join returning rt on br.borrow_id = rt.borrow_id
join books b on br.book_id = b.book_id
join readers r on br.readers_id = r.readers_id
where rt.return_date <= br.due_date;
-- Lấy tên sách và năm xuất bản của sách có số lần mượn lớn nhất.
select b.title as book_title, b.publication_year
from books b
join borrowing br on b.book_id = br.book_id
group by b.title, b.publication_year
having count(br.book_id) = (
    select max(borrow_count)
    from (select count(book_id) as borrow_count from borrowing group by book_id) as book_borrows
);