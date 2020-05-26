-- FUNCTION: public.generate_random_father_name()

-- DROP FUNCTION public.generate_random_father_name();

CREATE OR REPLACE FUNCTION public.generate_random_father_name(
	)
    RETURNS TABLE(some_name character) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$BEGIN 

RETURN QUERY 
SELECT nam.name
FROM (SELECT "Name".name
FROM "Name" 
WHERE sex='M' 
ORDER BY random() LIMIT 1) as nam;
END; 

$BODY$;

ALTER FUNCTION public.generate_random_father_name()
    OWNER TO postgres;
