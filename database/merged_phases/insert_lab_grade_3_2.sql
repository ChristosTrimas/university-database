
-- help function
CREATE OR REPLACE FUNCTION public.get_previous_lab_grade(
	stud_am integer,
	course_am character)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN 
RETURN (SELECT DISTINCT ON (r.amka, r.course_code) r.lab_grade FROM "Register" as r WHERE register_status = 'fail'  AND  r.lab_grade IS NOT NULL AND r.lab_grade > 5 AND r.amka = stud_am AND r.course_code = course_am ORDER BY amka ASC,course_code ASC,serial_number DESC);
END; 

$BODY$;




--basic function
CREATE OR REPLACE FUNCTION public.insert_lab_grade(
	semester integer)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
	--update register and insert new grades only when the value of final grade is NULL
	UPDATE "Register"
	SET 
		-- if non-existent previous grade, generate a random one.
		lab_grade = COALESCE(get_previous_lab_grade(amka,course_code), trunc(random()*9 +1))
		
	WHERE 
		register_status = 'approved' AND lab_grade IS NULL AND serial_number = semester AND final_grade IS NULL;

END;
$BODY$;


