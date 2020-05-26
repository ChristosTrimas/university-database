CREATE OR REPLACE FUNCTION public.get_student_grades(
	yr integer,
	acad_season text,
	code character)
    RETURNS TABLE(e_grade numeric, l_grade numeric, f_grade numeric, c_code character, s_num integer) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN 
RETURN QUERY
	(SELECT exam_grade, lab_grade, final_grade, course_code, serial_number FROM "Register" 
	WHERE amka = (SELECT amka FROM "Student" WHERE am = code) 
	AND exam_grade IS NOT NULL
	AND serial_number = (SELECT semester_id 
						 FROM "Semester" 
						 WHERE academic_year = yr AND academic_season = acad_season::semester_season_type));

END
$BODY$;

CREATE OR REPLACE FUNCTION public.get_enrolled_students(
	yr integer,
	acad_season text,
	code character)
    RETURNS TABLE(am character, name character, surname character, course_code character) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$BEGIN 
	RETURN QUERY (	SELECT s.am, s.name,s.surname, r.course_code 
					FROM "Register" r, "Student" s 
					WHERE r.register_status = 'approved' 
					AND r.amka = s.amka 
				  	AND r.course_code = code 
				  	AND r.serial_number = (SELECT semester_id FROM "Semester" WHERE academic_year = yr AND academic_season = acad_season::semester_season_type));

END
$BODY$;