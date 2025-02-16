create database ss12_2;
use ss12_2;

create table patients (
    patient_id int auto_increment primary key,
    name varchar(100) not null,
    dob date not null,
    gender enum('male', 'female') not null,
    phone varchar(15) unique
);

create table doctors (
    doctor_id int auto_increment primary key,
    name varchar(100) not null,
    specialization varchar(100) not null,
    phone varchar(15) unique,
    salary decimal(10, 2)
);

create table appointments (
    appointment_id int auto_increment primary key,
    patient_id int,
    doctor_id int,
    appointment_date datetime not null,
    status enum('scheduled', 'completed', 'cancelled') not null,
    foreign key (patient_id) references patients(patient_id),
    foreign key (doctor_id) references doctors(doctor_id)
);

create table prescriptions (
    prescription_id int auto_increment primary key,
    appointment_id int,
    medicine_name varchar(100) not null,
    dosage varchar(50) not null,
    duration varchar(50),
    notes varchar(255),
    foreign key (appointment_id) references appointments(appointment_id)
);
-- 2) Tạo bảng patient_error_log để lưu trữ thông tin về các lỗi khi thêm bệnh nhân.
CREATE TABLE patient_error_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_name VARCHAR(100),
    phone_number VARCHAR(15),
    error_message VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3) Tạo một trigger BEFORE INSERT trên bảng patients. Trigger này sẽ kiểm tra xem bệnh nhân có tồn tại trong hệ thống hay không (dựa trên họ tên và ngày sinh). 
DELIMITER //
create trigger before_insert_patients
before insert on patients
for each row
begin
    declare patient_exists int;
    select count(*) into patient_exists 
    from patients 
    where name = new.name and dob = new.dob;
    if patient_exists > 0 then
        insert into patient_error_log (patient_name, phone_number, error_message)
        values (new.name, new.phone, 'bệnh nhân đã tồn tại');
        signal sqlstate '45000' set message_text = 'patient already exists';
    end if;
end //
DELIMITER ;

-- 4) Thêm bệnh nhân để kiểm tra Trigger BEFORE INSERT
-- Thêm bệnh nhân hợp lệ
INSERT INTO patients (name, dob, gender, phone) VALUES ('John Doe', '1990-01-01', 'Male', '1234567890');
-- Thêm bệnh nhân trùng thông tin
INSERT INTO patients (name, dob, gender, phone) VALUES ('John Doe', '1990-01-01', 'Male', '0987654321');

-- 5) Tạo một trigger có tên CheckPhoneNumberFormat để kiểm tra xem số điện thoại của bệnh nhân khi thêm vào bảng patients có đúng định dạng không.
DELIMITER //
create trigger check_phone_number_format
before insert on patients
for each row
begin
    if not new.phone regexp '^[0-9]{10}$' then
        insert into patient_error_log (patient_name, phone_number, error_message)
        values (new.name, new.phone, 'số điện thoại không hợp lệ!');
        signal sqlstate '45000' set message_text = 'invalid phone number format';
    end if;
end //
DELIMITER ;

-- 6) Thêm 6 bản ghi sau vào bảng patients:
INSERT INTO patients (name, dob, gender, phone) VALUES
('Alice Smith', '1985-06-15', 'Female', '1234567895'),
('Bob Johnson', '1990-02-25', 'Male', '2345678901'),
('Carol Williams', '1975-03-10', 'Female', '3456789012'),
('Dave Brown', '1992-09-05', 'Male', '4567890abc'),  -- Số điện thoại không hợp lệ
('Eve Davis', '1980-12-30', 'Female', '56789xyz'),    -- Số điện thoại không hợp lệ
('Eve', '1980-12-13', 'Female', '56789');      -- Số điện thoại không hợp lệ

-- 7) Hiển thị lại bảng patient_error_log để kiểm tra.
select * from patient_error_log;

-- 8) Tạo một stored procedure có tên là UpdateAppointmentStatus 
DELIMITER //
create procedure update_appointment_status(in appointment_id int, in new_status enum('scheduled', 'completed', 'cancelled'))
begin
    update appointments 
    set status = new_status 
    where appointment_id = appointment_id;
end //
DELIMITER ;

-- 9) Tạo một trigger có tên UpdateStatusAfterPrescriptionInsert,
DELIMITER //
create trigger update_status_after_prescription_insert
after insert on prescriptions
for each row
begin
    call update_appointment_status(new.appointment_id, 'completed');
end //
DELIMITER ;

-- 10) Chạy đoạn code dưới đây

-- Them bac si
INSERT INTO doctors (name, specialization, phone, salary) 
VALUES ('Dr. John Smith', 'Cardiology', '1234567890', 5000.00);
INSERT INTO doctors (name, specialization, phone, salary) 
VALUES ('Dr. Alice Brown', 'Neurology', '0987654321', 6000.00);
-- Thêm cuộc hẹn 
INSERT INTO appointments (patient_id, doctor_id, appointment_date, status) 
VALUES (1, 1, '2025-02-15 09:00:00', 'Scheduled');
INSERT INTO appointments (patient_id, doctor_id, appointment_date, status) 
VALUES (2, 2, '2025-02-16 10:00:00', 'Scheduled');
INSERT INTO appointments (patient_id, doctor_id, appointment_date, status) 
VALUES (3, 1, '2025-02-17 14:00:00', 'Scheduled');

-- 11) Chạy lần lượt theo thứ tự và quan sát appointments có id=1 trước và sau khi thêm 1 bản ghi cho prescriptions

SELECT * FROM appointment;

-- Thêm một đơn thuốc cho cuộc hẹn với ID = 1

INSERT INTO prescriptions (appointment_id, medicine_name, dosage, duration, notes) 

VALUES (1, 'Paracetamol', '500mg', '5 days', 'Take one tablet every 6 hours');

SELECT * FROM appointments;
