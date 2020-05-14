CREATE OR REPLACE FUNCTION public.prof_4_2_office_hours()
    RETURNS table(name character, surname character, course_code character(7), start_time integer,
				 end_time integer, weekday integer)
    LANGUAGE 'plpgsql'

    COST 100
    immutable 
AS $$
BEGIN
RETURN query

select pf.name, pf.surname, cr.course_code, la.start_time, la.end_time, la.weekday
from "Professor" pf, "CourseRun" cr, "LearningActivity" la, "Semester" se
where cr.serial_number = se.semester_id and cr.course_code = la.course_code and pf.amka = cr.amka_prof1 and la.activity_type = 'office_hours'
and se.semester_status ='present'

union 

select pf.name, pf.surname, cr.course_code, la.start_time, la.end_time, la.weekday
from "Professor" pf, "CourseRun" cr, "LearningActivity" la, "Semester" se
where cr.serial_number = se.semester_id and cr.course_code = la.course_code and pf.amka = cr.amka_prof2 and la.activity_type = 'office_hours'
and se.semester_status = 'present'

order by name, surname;

END $$;

ALTER FUNCTION public.create_email(character varying, character varying)
    OWNER TO postgres;
