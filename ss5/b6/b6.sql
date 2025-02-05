-- Sử dụng lại cơ sở dữ liệu ss5
USE ss5;

-- Tạo bảng Guests
CREATE TABLE Guests (
    GuestID INT AUTO_INCREMENT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(15) NOT NULL,
    Email VARCHAR(100),
    Gender ENUM('Nam', 'Nu')
);

-- Tạo bảng Rooms
CREATE TABLE Rooms (
    RoomID INT AUTO_INCREMENT PRIMARY KEY,
    RoomNumber VARCHAR(10) NOT NULL,
    RoomType ENUM('Standard', 'Deluxe', 'Suite') NOT NULL,
    PricePerNight DECIMAL(10, 2) NOT NULL,
    Status ENUM('Available', 'Occupied', 'Reserved') NOT NULL
);

-- Tạo bảng Bookings
CREATE TABLE Bookings (
    BookingID INT AUTO_INCREMENT PRIMARY KEY,
    GuestID INT NOT NULL,
    RoomID INT NOT NULL,
    CheckInDate DATE NOT NULL,
    CheckOutDate DATE NOT NULL,
    TotalPrice DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (GuestID) REFERENCES Guests(GuestID),
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID)
);
-- Chèn dữ liệu vào bảng Guests
INSERT INTO Guests (FullName, PhoneNumber, Email, Gender)
VALUES
    ('Nguyen Van A', '0901234567', 'nguyenvana@example.com', 'Nam'),
    ('Tran Thi B', '0912345678', 'tranthib@example.com', 'Nu'),
    ('Pham Van C', '0923456789', NULL, 'Nam'),
    ('Le Thi D', '0934567890', 'lethid@example.com', 'Nu');

-- Chèn dữ liệu vào bảng Rooms
INSERT INTO Rooms (RoomNumber, RoomType, PricePerNight, Status)
VALUES
    ('101', 'Standard', 500000, 'Available'),
    ('102', 'Deluxe', 1000000, 'Available'),
    ('201', 'Suite', 2000000, 'Available'),
    ('102', 'Deluxe', 1000000, 'Occupied'), 
    ('101', 'Standard', 500000, 'Reserved'); 

-- Chèn dữ liệu vào bảng Bookings
INSERT INTO Bookings (GuestID, RoomID, CheckInDate, CheckOutDate, TotalPrice)
VALUES
    (1, 2, '2025-01-10', '2025-01-12', 2000000), 
    (2, 3, '2025-01-15', '2025-01-18', 6000000), 
    (3, 1, '2025-01-20', '2025-01-22', 1000000), 
    (4, 2, '2025-01-18', '2025-01-20', 2000000), 
    (1, 1, '2025-01-23', '2025-01-25', 1000000); 

-- B6
-- 2
select g.FullName, g.Email, r.RoomType, b.CheckInDate
from Bookings b
join Guests g on b.GuestID = g.GuestID
join Rooms r on b.RoomID = r.RoomID
where r.RoomType = 'Deluxe'
and b.CheckInDate between '2025-01-01' and '2025-01-31'
order by b.CheckInDate asc
limit 5;

-- 3
select r.RoomNumber, r.RoomType, g.GuestID
from Bookings b
join Guests g on b.GuestID = g.GuestID
join Rooms r on b.RoomID = r.RoomID
where g.Email is not null
order by r.RoomType asc, r.RoomNumber asc
limit 5;

-- 4
select g.FullName, g.Email, g.PhoneNumber
from Bookings b
join Guests g on b.GuestID = g.GuestID
where g.Gender = 'Nam'
group by g.GuestID, g.FullName, g.Email
having count(b.BookingID) >= 2;

-- 5
select g.FullName, g.PhoneNumber, r.RoomType, r.PricePerNight
from Bookings b
join Guests g on b.GuestID = g.GuestID
join Rooms r on b.RoomID = r.RoomID
where r.PricePerNight >= 1000000
and g.PhoneNumber <> '0901234567';

