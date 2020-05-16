CREATE OR REPLACE FUNCTION public.find_4_5_after()
    RETURNS TABLE(status character, course_code character) 
    LANGUAGE 'plpgsql'

    COST 100
    IMMUTABLE 
    ROWS 1000
AS $$
BEGIN
RETURN query

select 
	case when la.start_time >= 16 and la.end_time <= 20 then cast('ΝΑΙ' as character(3))
	     else cast('ΟΧΙ' as character(3))
	end status,
	cs.course_code
from "LearningActivity" la, "Course" cs
where cs.obligatory = 'on' and cs.course_code = la.course_code;

END;
$$;

ALTER FUNCTION public.find_4_5_after()
    OWNER TO postgres;
