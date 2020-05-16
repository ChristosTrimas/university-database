CREATE OR REPLACE FUNCTION public.find_4_8_room_dif_sub()
    RETURNS TABLE(summary integer, room integer) 
    LANGUAGE 'plpgsql'

    COST 100
    IMMUTABLE 
    ROWS 1000
AS $BODY$
BEGIN
RETURN query

select cast(count(la.course_code) as integer), r.room_id
from "LearningActivity" la, "Room" r, "Semester" se
where la.room_id = r.room_id and se.semester_status = 'present' and la.serial_number = se.semester_id
group by r.room_id;
END;
$BODY$;

ALTER FUNCTION public.find_4_8_room_dif_sub()
    OWNER TO postgres;
