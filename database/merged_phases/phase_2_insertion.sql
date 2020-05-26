CREATE OR REPLACE FUNCTION public.insert_data_phase_2(num integer,reg_date date)
    RETURNS void
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN 
	FOR i IN 1..num LOOP
	PERFORM insert_students_3_1(num,imerominia);
	END LOOP;				
END

$BODY$;
