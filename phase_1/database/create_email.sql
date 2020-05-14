-- FUNCTION: public.create_email(character varying, character varying)

-- DROP FUNCTION public.create_email(character varying, character varying);

CREATE OR REPLACE FUNCTION public.create_email(
	person_name character varying,
	person_surname character varying)
    RETURNS character varying
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$BEGIN
RETURN concat(LEFT(LOWER(person_name),1), LOWER(person_surname),'@isc.tuc.gr');

END $BODY$;

ALTER FUNCTION public.create_email(character varying, character varying)
    OWNER TO postgres;
