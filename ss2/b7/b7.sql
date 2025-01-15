create table order_detail(
	cus_id int,
    order_id int,
    foreign key (cus_id) references customers(cus_id),
    foreign key (order_id) references orders(order_id),
    primary key (cus_id, order_id),
    quantity int not null
);

ALTER TABLE order_detail
ADD CONSTRAINT fk_mahd
FOREIGN KEY (order_id) REFERENCES HoaDon(MaHD);

ALTER TABLE order_detail
ADD CONSTRAINT fk_masp
FOREIGN KEY (product_id) REFERENCES SanPham(MaSP);

SELECT 
    HoaDon.MaHD, 
    SanPham.MaSP, 
    SanPham.TenSP, 
    order_detail.quantity
FROM 
    HoaDon
JOIN 
    order_detail ON HoaDon.MaHD = order_detail.order_id
JOIN 
    SanPham ON order_detail.product_id = SanPham.MaSP;