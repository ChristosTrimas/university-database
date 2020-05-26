CREATE OR REPLACE FUNCTION public.insert_professors_3_1(
	num_entries integer)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$

DECLARE next_amka integer;

BEGIN
	
	next_amka := (SELECT max("Professor".amka) FROM "Professor");
	-- amka calculation, sequence already declared.
	PERFORM setval(format('%I', 'Professor_amka_seq'),  next_amka);
	PERFORM setval('prof_am', next_amka);
	
	INSERT INTO "Professor"(amka,name,father_name,surname, email, "labJoins" , rank)
	
	SELECT 	nextval(format('%I', 'Professor_amka_seq')), 
			n.name, 
			fn.name, 
			adapt_surname(s.surname, n.sex), 
			CONCAT('p' ,floor(random()*((EXTRACT (YEAR FROM CURRENT_DATE))::integer-2000 + 1) + 2000),'0', (nextval('prof_am')::integer + 30)::text,'@isc.tuc.gr')::character(30), 
			ceil(random()*10)::integer, 
			('[0:3]={full,assistant,associate,lecturer}'::text[])[trunc(random()*4)]::rank_type 

	FROM random_surnames(num_entries) AS s, random_names(num_entries) AS n, generate_random_father_names(num_entries) AS fn 
	WHERE s.id = n.id AND n.id = fn.id;

END;

$BODY$;
