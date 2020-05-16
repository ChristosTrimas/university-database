CREATE OR REPLACE FUNCTION public.find_4_10_amka(MAX_C integer, MIN_C integer)
    RETURNS TABLE(amka integer, surname character, name character) 
    LANGUAGE 'plpgsql'

    COST 100
    IMMUTABLE 
    ROWS 1000
AS $BODY$
BEGIN
RETURN query
select pf.amka, pf.surname, pf.name
from "Professor" pf, "Participates" part, "Room" r
where part.room_id = r.room_id and r.capacity <= MAX_C and r.capacity >= MIN_C and pf.amka = part.amka
	and part.role = 'responsible';
END;
$BODY$;

ALTER FUNCTION public.find_4_10_amka(MAX_C integer, MIN_C integer)
    OWNER TO postgres;
