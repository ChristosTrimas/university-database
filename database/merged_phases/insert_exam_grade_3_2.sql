CREATE OR REPLACE FUNCTION public.insert_exam_grade(
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
		exam_grade = trunc(random()*9 +1)
		
	WHERE 
		register_status = 'approved' AND exam_grade IS NULL AND serial_number = semester;

END;
$BODY$;
