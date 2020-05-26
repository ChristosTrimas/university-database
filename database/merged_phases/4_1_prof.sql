CREATE OR REPLACE FUNCTION public.find_4_1_prof()
    RETURNS table(name character, surname character, amka int)
    LANGUAGE 'plpgsql'

    COST 100
    IMMUTABLE 
AS $$
BEGIN
RETURN query
select pf.name, pf.surname, pf.amka
from "Professor" pf , "Room" r , "Participates" pa
where r.room_id = pa.room_id and r.capacity > 30 and pf.amka = pa.amka;
END;
$$;

ALTER FUNCTION public.find_4_1_prof()
    OWNER TO postgres;
