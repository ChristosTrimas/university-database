create view b_2_1 as
select part.room_id, part.course_code, (r.capacity - COUNT(part.amka)) as avail_space, part.start_time, part.end_time, part.weekday
from "Student" st, "Participates" part, "Semester" se, "Room" r
where st.amka = part.amka and se.semester_status = 'present' and se.semester_id = part.serial_number and r.room_id = part.room_id
group by part.room_id, part.course_code, r.capacity, part.start_time, part.end_time, part.weekday;