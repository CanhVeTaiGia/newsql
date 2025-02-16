use ss12_2;

/*
2) Tạo một stored procedure GetDoctorDetails nhận vào input_doctor_id và trả về thông tin về bác sĩ bao gồm: 
tên bác sĩ (doctor_name), chuyên môn (specialization), tổng số bệnh nhân mà bác sĩ đã khám (total_patients),
tổng doanh thu từ các cuộc hẹn của bác sĩ (total_revenue), và tổng số thuốc kê đơn mà bác sĩ đã kê (total_medicines_prescribed).
*/
DELIMITER //
create procedure getdoctordetails(in input_doctor_id int)
begin
    select d.name as doctor_name, d.specialization, count(a.patient_id) as total_patients, coalesce(sum(pr.dosage * d.salary), 0) 
    as total_revenue, count(pr.medicine_name) as total_medicines_prescribed
    from doctors d
    left join appointments a on d.doctor_id = a.doctor_id
    left join prescriptions pr on a.appointment_id = pr.appointment_id
    where d.doctor_id = input_doctor_id
    group by d.doctor_id, d.name;
end //
DELIMITER ;

-- 3) Tạo bảng cancellation_logs
create table cancellation_logs (
    log_id int auto_increment primary key,
    appointment_id int not null,
    log_message varchar(255) not null,
    log_date datetime not null,
    foreign key (appointment_id) references appointments(appointment_id)
);

-- 4) Tạo bảng appointment_logs
create table appointment_logs (
    log_id int auto_increment primary key,
    appointment_id int not null,
    log_message varchar(255) not null,
    log_date datetime not null,
    foreign key (appointment_id) references appointments(appointment_id)
);

-- 5) Tạo trigger AFTER DELETE trên bảng appointments:
DELIMITER //
create trigger after_delete_appointment
after delete on appointments
for each row
begin
    delete from prescriptions where appointment_id = old.appointment_id;
    if old.status = 'Cancelled' then
        insert into cancellation_logs (appointment_id, log_message, log_date)
        values (old.appointment_id, 'Cancelled appointment was deleted', now());
    end if;
    if old.status = 'Completed' then
        insert into appointment_logs (appointment_id, log_message, log_date)
        values (old.appointment_id, 'Completed appointment was deleted', now());
    end if;
end //
DELIMITER ;

-- 6) Tạo view FullRevenueReport 
create view fullrevenuereport as
select d.doctor_id, d.name as doctor_name, count(a.appointment_id) as total_appointments, count(distinct a.patient_id) as total_patients, sum(p.medicine_name is not null) as total_medicines, coalesce(sum(pr.dosage * d.salary), 0) as total_revenue
from doctors d
left join appointments a on d.doctor_id = a.doctor_id
left join prescriptions pr on a.appointment_id = pr.appointment_id
group by d.doctor_id, d.name;

-- 7) Gọi procedure GetDoctorDetails với tham số input_doctor_id bất kì
call getdoctordetails(2);

-- 8) Kiểm tra trigger AFTER DELETE
-- Xóa cuộc hẹn với trạng thái "Cancelled"

DELETE FROM appointments WHERE appointment_id = 3;

-- Xóa cuộc hẹn với trạng thái "Completed"

DELETE FROM appointments WHERE appointment_id = 2;

-- 9) Truy vấn view FullRevenueReport
select * from fullrevenuereport;
