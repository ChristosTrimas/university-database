CREATE OR REPLACE FUNCTION public.find_4_6_lab()
    RETURNS TABLE(course_code character, title character) 
    LANGUAGE 'plpgsql'

    COST 100
    IMMUTABLE 
    ROWS 1000
AS $$
BEGIN
RETURN query

select cs.course_code, cs.course_title
from "Course" cs, "LearningActivity" la, "Room" r, "Semester" se
where cs.obligatory = 'on' and cs.lab_hours <> 0 and la.room_id = r.room_id  and r.room_type <> 'lab_room'
	 and cs.course_code = la.course_code and se.semester_status = 'present' and se.semester_id = la.serial_number;

END;
$$;

ALTER FUNCTION public.find_4_6_lab()
    OWNER TO postgres;
