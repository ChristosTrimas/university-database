CREATE OR REPLACE FUNCTION public.generate_random_father_names(
	n integer)
    RETURNS TABLE(name character, sex character, id integer) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN 
RETURN QUERY 
SELECT nam.name, nam.sex, row_number() OVER ()::integer
FROM (SELECT "Name".name, "Name".sex
FROM "Name"
WHERE "Name".sex = 'M'
ORDER BY random() LIMIT n) as nam;
END; 

$BODY$;