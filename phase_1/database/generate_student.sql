-- FUNCTION: public.generate_student(integer, date)

-- DROP FUNCTION public.generate_student(integer, date);

CREATE OR REPLACE FUNCTION public.generate_student(
	stud_num integer,
	curr_date date)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$BEGIN 
	CREATE SEQUENCE IF NOT EXISTS student_amka_insertion_seq;
	PERFORM setval('student_amka_insertion_seq', (SELECT max(amka) FROM "Student"));
	
	
	INSERT INTO "Student"(amka, name, father_name, surname, email,am,entry_date)

	SELECT  nextval('student_amka_insertion_seq'), 
			n.name,
			generate_random_father_name(),
			adapt_surname(s.surname,n.sex),
			create_email(s.surname, n.name), 
			create_am(CAST(EXTRACT(YEAR FROM curr_date) as INTEGER), (SELECT nextval(format('%I', 'Student_amka_seq')))::integer),
			curr_date
	FROM   (random_names(stud_num) n JOIN random_surnames(stud_num) s USING (id)); 
	
END;$BODY$;

ALTER FUNCTION public.generate_student(integer, date)
    OWNER TO postgres;
