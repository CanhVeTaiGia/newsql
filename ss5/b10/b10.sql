use ss5;

-- B10
-- 2
select 
    concat(p.fullname, ' (', year(a.appointmentdate) - year(p.dateofbirth), ') - ', d.fullname) as patientdoctorinfo,
    a.appointmentdate, m.diagnosis
from appointments a
join patients p on a.patientid = p.patientid
join doctors d on a.doctorid = d.doctorid
join medicalrecords m on a.patientid = m.patientid and a.doctorid = m.doctorid
where a.appointmentdate between '2025-01-20' and '2025-01-25'
order by a.appointmentdate;

-- 3
select 
    p.fullname as PatientName,
    year(a.appointmentdate) - year(p.dateofbirth) as AgeAtAppointment,
    a.appointmentdate as AppointmentDate,
    case
        when year(a.appointmentdate) - year(p.dateofbirth) > 50 then 'Nguy cơ cao'
        when year(a.appointmentdate) - year(p.dateofbirth) between 30 and 50 then 'Nguy cơ trung bình'
        else 'Nguy cơ thấp'
    end as RiskLevel
from 
    appointments a
join 
    patients p on a.patientid = p.patientid
where 
    a.appointmentdate between '2025-01-20' and '2025-01-25'
order by 
    a.appointmentdate;

-- 4
delete a
from appointments a
join patients p on a.patientid = p.patientid
join doctors d on a.doctorid = d.doctorid
where 
    (year(a.appointmentdate) - year(p.dateofbirth)) > 30
    and (d.specialization = 'noi tong quat' or d.specialization = 'chan thuong chinh hinh');

-- 5
select 
    p.fullname as PatientName,
    d.specialization as Specialization,
    year(a.appointmentdate) - year(p.dateofbirth) as AgeAtAppointment
from 
    appointments a
join 
    patients p on a.patientid = p.patientid
join 
    doctors d on a.doctorid = d.doctorid
order by 
    a.appointmentdate;
