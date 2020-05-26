create or replace view weekly_6_2_program as
select part.room_id, part.weekday, part.start_time, part.end_time, p.surname, p.name, part.course_code
from "Professor" p, "Participates" part, "LearningActivity" la, "Semester" se
where se.semester_status = 'present' and part.amka = p.amka and part.room_id = la.room_id and part.course_code = la.course_code and 
	part.start_time = la.start_time and part.end_time = la.end_time and se.semester_id = part.serial_number
order by la.weekday;