CREATE or replace VIEW passed_6_1_students as
select count(*), re.serial_number, re.course_code, se.semester_id
from "Register" re, "Semester" se
where re.register_status = 'pass' and re.lab_grade > 8
group by re.serial_number,re.course_code,se.semester_id;
