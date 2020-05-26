 
---------used function

CREATE OR REPLACE FUNCTION public.copy_existent_courserun(
    sem_id integer)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
    new_serial_number integer;

BEGIN
        INSERT INTO "CourseRun"
        SELECT DISTINCT ON (c.course_code) c.course_code,sem_id,c.exam_min,c.lab_min,c.exam_percentage,c.labuses,c.semesterrunsin,c.amka_prof1,c.amka_prof2
        FROM    ("CourseRun" c JOIN (SELECT course_code,typical_season FROM "Course") AS "co" USING (course_code)) 
        WHERE co.typical_season = (SELECT academic_season FROM "Semester" WHERE semester_id=sem_id-2)
        ORDER BY c.course_code DESC;
   
END
$BODY$;



-----------trigger function.

CREATE FUNCTION public.insert_courserun()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$

BEGIN

 
        IF NEW.semester_status = 'future' THEN  
            PERFORM copy_existent_courserun(NEW.semester_id);
            RAISE NOTICE 'Courses from the last semester are getting copied!';
            RETURN NEW;
        ELSE
            -- shouldn't be here bro.
            RAISE EXCEPTION 'Exception Thrown! Course has no ancesstor to fetch info from.';
            RETURN NULL;    
        END IF; 
    

   

END
$BODY$;


------------trigger definition.

-- Trigger: create_future_courses

-- DROP TRIGGER create_future_courses ON public."Semester";

CREATE TRIGGER create_future_courses
    AFTER INSERT
    ON public."Semester"
    FOR EACH ROW
    EXECUTE PROCEDURE public.insert_courserun();