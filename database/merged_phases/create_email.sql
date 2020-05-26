CREATE OR REPLACE FUNCTION public.create_email(
	stud_amka character varying,
	entry_date date)
    RETURNS character varying
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$BEGIN
RETURN concat('s', EXTRACT(YEAR FROM entry_date)::text ,lpad(stud_amka, 9-LENGTH(stud_amka),'0') :: text,'@isc.tuc.gr');

END $BODY$;