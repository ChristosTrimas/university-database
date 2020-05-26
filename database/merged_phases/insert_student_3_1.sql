

CREATE OR REPLACE FUNCTION public.insert_students_3_1(
	stud_num integer,
	curr_date date)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$

BEGIN 

	

	-- amka calculation
	CREATE SEQUENCE IF NOT EXISTS student_amka_insertion_seq;
	PERFORM setval('student_amka_insertion_seq', (SELECT max(amka) FROM "Student"));
	
	--am calculation, COALESCE usage -> if null, init with zeros.
	CREATE SEQUENCE IF NOT EXISTS student_am_insertion_seq;
	PERFORM setval('student_am_insertion_seq',(SELECT COALESCE(max(am)::integer, concat(extract(YEAR from curr_date)::text, '000000')::integer)FROM "Student" WHERE left(am,4) = (extract(YEAR from curr_date))::text)::integer);
	

	PERFORM setval('student_am', (SELECT max(amka) FROM "Student"));
	
	
	
	--insert the data.
	INSERT INTO "Student"(amka, name, father_name, surname, email,am,entry_date)

	SELECT  nextval('student_amka_insertion_seq'), 
			n.name,
			fn.name,
			adapt_surname(s.surname,n.sex),
			create_email(nextval('student_am')::text, curr_date), 
			create_am(CAST(EXTRACT(YEAR FROM curr_date) as INTEGER), right((nextval('student_am_insertion_seq'))::text,6)::integer),
			curr_date
	FROM    random_names(stud_num) AS n, random_surnames(stud_num) AS s, generate_random_father_names(stud_num) AS fn
	WHERE 	s.id = n.id AND n.id = fn.id;  
	
	
	--join using id, could also work here!
END;
$BODY$;

