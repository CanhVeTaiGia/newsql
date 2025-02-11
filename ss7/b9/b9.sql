create database ticketfilm;
use ticketfilm;

create table tblphim (
    phimid int primary key auto_increment,
    ten_phim nvarchar(30),
    loai_phim nvarchar(25),
    thoi_gian int
);

create table tblphong (
    phongid int primary key auto_increment,
    ten_phong nvarchar(20),
    trang_thai tinyint
);

create table tblghe (
    gheid int primary key auto_increment,
    phongid int,
    so_ghe varchar(10),
    foreign key (phongid) references tblphong(phongid)
);

create table tblve (
    phimid int,
    gheid int,
    ngay_chieu datetime,
    trang_thai nvarchar(20),
    foreign key (phimid) references tblphim(phimid),
    foreign key (gheid) references tblghe(gheid)
);

insert into tblphim (ten_phim, loai_phim, thoi_gian) values
('em bé hà nội', 'tâm lý', 90),
('nhiệm vụ bất khả thi', 'hành động', 100),
('dị nhân', 'viễn tưởng', 90),
('cuốn theo chiều gió', 'tình cảm', 120);

insert into tblphong (ten_phong, trang_thai) values
('phòng chiếu 1', 1),
('phòng chiếu 2', 1),
('phòng chiếu 3', 0);

insert into tblghe (phongid, so_ghe) values
(1, 'a3'),
(1, 'b5'),
(2, 'a7'),
(2, 'd1'),
(3, 't2');

insert into tblve (phimid, gheid, ngay_chieu, trang_thai) values
(1, 1, '2008-10-20', 'đã bán'),
(1, 3, '2008-11-20', 'đã bán'),
(1, 4, '2008-12-23', 'đã bán'),
(2, 1, '2009-02-14', 'đã bán'),
(3, 1, '2009-02-14', 'đã bán'),
(2, 5, '2009-03-08', 'chưa bán'),
(2, 3, '2009-03-08', 'chưa bán');

-- 1. Hiển thị danh sách các phim (chú ý: danh sách phải được sắp xếp theo trường Thoi_gian)
select * from tblphim order by thoi_gian;

-- 2. Hiển thị Ten_phim có thời gian chiếu dài nhất
select ten_phim from tblphim order by thoi_gian desc limit 1;

--3. hiển thị ten_phim có thời gian chiếu ngắn nhất
select ten_phim from tblphim order by thoi_gian asc limit 1;

-- 4. hiển thị danh sách so_ghe bắt đầu bằng 'a'
select so_ghe from tblghe where so_ghe like 'a%';

-- 5. sửa kiểu dữ liệu của trang_thai trong tblphong
alter table tblphong modify trang_thai varchar(25);

-- 6. cập nhật giá trị trang_thai trong tblphong
update tblphong set trang_thai = 
    case 
        when trang_thai = '0' then 'đang sửa'
        when trang_thai = '1' then 'đang sử dụng'
        else 'unknow'
    end;

-- 7. hiển thị danh sách tên phim có độ dài từ 15 đến 25 ký tự
select ten_phim from tblphim where length(ten_phim) > 15 and length(ten_phim) < 25;

-- 8. hiển thị ten_phong và trang_thai trong một cột
select concat(ten_phong, ' - ', trang_thai) as 'trạng thái phòng chiếu' from tblphong;

-- 9. tạo view tblrank
create view tblrank as
select row_number() over (order by ten_phim) as stt, ten_phim, thoi_gian from tblphim;

-- 10. thêm trường mo_ta vào tblphim
alter table tblphim add mo_ta nvarchar(max);

update tblphim set mo_ta = concat('đây là film thể loại ', loai_phim);

select * from tblphim;

update tblphim set mo_ta = replace(mo_ta, 'bộ phim', 'film');

select * from tblphim;

-- 11. xóa tất cả khóa ngoại
alter table tblghe drop foreign key tblghe_ibfk_1;
alter table tblve drop foreign key tblve_ibfk_1;
alter table tblve drop foreign key tblve_ibfk_2;

-- 12. xóa dữ liệu trong tblghe
delete from tblghe;

-- 13. hiển thị ngày giờ hiện tại và cộng thêm 5000 phút
select ngay_chieu, date_add(ngay_chieu, interval 5000 minute) as ngay_cong from tblve;
