CREATE OR REPLACE FUNCTION public.find_4_3_max_grades(se integer, gtype character)
    RETURNS TABLE(grade decimal,course_code character(7)) --check documentation for decimal
    LANGUAGE 'plpgsql'

    COST 100
    IMMUTABLE 
    ROWS 1000
AS $$
BEGIN
RETURN query

select case 
		when gtype = 'lab_grade' then max(reg.lab_grade)
		when gtype = 'exam_grade' then max(reg.exam_grade)
		when gtype = 'final_grade' then max(reg.final_grade)
		else 0
		end grade,--the name here is viatal!
		reg.course_code
from "Register" reg
where reg.serial_number = se
group by reg.course_code
order by grade desc;

END;
$$;
ALTER FUNCTION public.find_4_3_max_grades(se integer, gtype character)
    OWNER TO postgres;