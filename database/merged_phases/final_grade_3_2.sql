CREATE OR REPLACE FUNCTION public.calc_final_grade_3_2(
	)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
	
	UPDATE "Register" r
		SET final_grade = 	CASE 
						 	WHEN c.lab_hours > 0 THEN  r.exam_grade * crs.exam_percentage + r.lab_grade * (1 - crs.exam_percentage)
							WHEN c.lab_hours = 0 THEN r.exam_grade
							WHEN r.exam_grade <crs.exam_min OR r.lab_grade<crs.lab_min THEN 0
							ELSE 0
							END
		FROM "CourseRun" AS crs, "Course" AS c
		WHERE r.serial_number = crs.serial_number
		AND r.course_code = crs.course_code
		AND crs.course_code = c.course_code
		AND r.exam_grade >=crs.exam_min
		AND r.lab_grade>=crs.lab_min
		AND register_status = 'approved';
END;
$BODY$;