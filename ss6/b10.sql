use ss6;
-- 2
delete a from appointments a
join doctors d on a.doctorid = d.doctorid
where d.fullname = 'Phan Huong' and a.appointmentdate < curdate();

select a.appointmentid,p.fullname as patientname, d.fullname as doctorname,a.appointmentdate,a.status
from appointments a
join patients p on a.patientid = p.patientid
join doctors d on a.doctorid = d.doctorid;

-- 3
update appointments a
set a.status = 'Dang chờ'
where a.appointmentdate >= curdate()
and a.patientid = (select patientid from patients where fullname = 'Nguyen Van An')
and a.doctorid = (select doctorid from doctors where fullname = 'Phan Huong');

select a.appointmentid,p.fullname as patientname,d.fullname as doctorname,a.appointmentdate,a.status
from appointments a
join patients p on a.patientid = p.patientid
join doctors d on a.doctorid = d.doctorid;

-- 4
select p.fullname as patientname,d.fullname as doctorname,a.appointmentdate,m.diagnosis from appointments a
join patients p on a.patientid = p.patientid
join doctors d on a.doctorid = d.doctorid
join medicalrecords m on a.appointmentid = m.recordid
where (select count(*) from appointments a2 where a2.patientid = a.patientid and a2.doctorid = a.doctorid) >= 2
order by p.fullname, d.fullname, a.appointmentdate;

-- 5
select concat('BỆNH NHÂN: ', upper(p.fullname), ' - BÁC SĨ: ', upper(d.fullname)) as patient_doctor,a.appointmentdate,m.diagnosis,a.status
from appointments a
join patients p on a.patientid = p.patientid
join doctors d on a.doctorid = d.doctorid
join medicalrecords m on a.appointmentid = m.recordid
order by a.appointmentdate asc;

-- 6
select concat('BỆNH NHÂN: ', upper(p.fullname), ' - BÁC SĨ: ', upper(d.fullname)) as patient_doctor,a.appointmentdate,m.diagnosis,a.status
from appointments a
join patients p on a.patientid = p.patientid
join doctors d on a.doctorid = d.doctorid
join medicalrecords m on a.appointmentid = m.recordid
order by a.appointmentdate asc;
