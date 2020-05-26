
CREATE OR REPLACE FUNCTION public.insert_labstaff_3_1(
	num_entries integer)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$

DECLARE next_amka integer;

BEGIN
	
	next_amka := (SELECT max("LabStaff".amka) FROM "LabStaff");
	-- amka calculation.
	CREATE SEQUENCE IF NOT EXISTS LabStaff_amka_seq;
	PERFORM setval(format('%I', 'LabStaff_amka_seq'),  next_amka);
	
	CREATE SEQUENCE IF NOT EXISTS labstaff_am;
	PERFORM setval('labstaff_am', next_amka);
	
	INSERT INTO "LabStaff"(amka,name,father_name,surname, email, labworks , "level")
	
	SELECT 	nextval(format('%I', 'LabStaff_amka_seq')), 
			n.name, 
			fn.name,
			adapt_surname(s.surname, n.sex), 
			CONCAT('l' ,floor(random()*((EXTRACT (YEAR FROM CURRENT_DATE))::integer-2000 + 1) + 2000),'0', (nextval('labstaff_am'))::text,'@isc.tuc.gr')::character(30), 
			ceil(random()*10)::integer, 
			('[0:3]={A,B,C,D}'::text[])[trunc(random()*4)]::level_type

	FROM random_surnames(num_entries) AS s, random_names(num_entries) AS n, generate_random_father_names(num_entries) as fn 
	WHERE s.id = n.id AND n.id = fn.id;

END;

$BODY$;
