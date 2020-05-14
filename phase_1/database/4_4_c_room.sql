CREATE OR REPLACE FUNCTION public.find_4_4_curr_c_r()
    RETURNS TABLE(am integer, reg_year integer) 
    LANGUAGE 'plpgsql'

    COST 100
    IMMUTABLE 
    ROWS 1000
AS $$
BEGIN
RETURN query

select st.amka, CAST(EXTRACT(YEAR FROM st.entry_date) as INTEGER)
from "Student" st, "Semester" se, "Room" r, "LearningActivity" la, "Register" reg
where st.amka = reg.amka and se.semester_status = 'present' and la.course_code = reg.course_code
	and la.serial_number = se.semester_id and la.room_id = r.room_id and r.room_type = 'computer_room';

END;
$$;

ALTER FUNCTION public.find_4_4_curr_c_r()
    OWNER TO postgres;
