/*
	a. các vấn đề trong bảng
		- Thiếu khóa chính (primary key): không có cột nào được chỉ định là khóa chính để đảm bảo mỗi sinh viên chỉ có một bản ghi duy nhất.
		- Thiếu ràng buộc not null: Các cột không có ràng buộc not null, có thể cho phép dữ liệu rỗng.
        - Thiếu ràng buộc kiểm tra (check): cột điểm(score) không có ràng buộc kiểm tra, dẫn đến khả năng nhập điểm ngoài phạm vi (0-10).
*/

use ss2;
create table score(
	student_id varchar(20) primary key not null,
    score int not null check(score between 0 and 10)
)