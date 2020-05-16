CREATE OR REPLACE FUNCTION public.find_4_7_workload(
	)
    RETURNS TABLE(amka integer, surname character, first_name character, workload integer) 
    LANGUAGE 'plpgsql'

    COST 100
    IMMUTABLE 
    ROWS 1000
AS $BODY$
BEGIN
RETURN query

(select ls.amka, ls.surname, ls.name,CAST(sum(part.end_time - part.start_time) as integer)
from "LabStaff" ls, "Participates" part, "Semester" se
where  ls.amka = part.amka and se.semester_status = 'present' 
group by ls.amka)

union

select ls.amka, ls.surname,ls.name,0
from "LabStaff" ls;
END;
$BODY$;

ALTER FUNCTION public.find_4_7_workload()
    OWNER TO postgres;
