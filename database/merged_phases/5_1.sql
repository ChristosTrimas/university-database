-- help functions

CREATE OR REPLACE FUNCTION public.get_person_participation(
	person_amka integer)
    RETURNS TABLE(start_time integer, end_time integer, weekday integer) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN 
	RETURN QUERY 
	SELECT  p.start_time, p.end_time, p.weekday
	FROM public."Participates" as p
	WHERE p.amka = person_amka;

END
$BODY$;


CREATE OR REPLACE FUNCTION public.get_lab_activities(
	)
    RETURNS TABLE(course_code character) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$BEGIN 
	RETURN QUERY
	(	SELECT  lr.course_code
		FROM public."LearningActivity" as lr
		WHERE activity_type = 'lab' OR activity_type = 'computer_lab');

END
$BODY$;


CREATE OR REPLACE FUNCTION public.get_course_lab_hours(
	c_code character)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$BEGIN 
	RETURN
	(SELECT  c.lab_hours
	FROM public."Course" as c
	WHERE c.course_code = c_code);

END
$BODY$;




--trigger functions

CREATE FUNCTION public.check_responsible_participation()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$BEGIN

IF NEW.start_time NOT IN (SELECT start_time FROM get_person_participation(NEW.amka) WHERE weekday = NEW.weekday) AND NEW.end_time NOT IN (SELECT start_time FROM get_person_participation(NEW.amka) WHERE weekday = NEW.weekday) AND NEW.role = 'responsible' THEN
	RETURN NEW;
ELSE 
	IF NEW.role = 'responsible' THEN
		RAISE EXCEPTION 'Violation of person-independency constrains for participation, the "Person" is occupied at current date-time';
		RETURN NULL;
	ELSE
		RETURN NEW;
	END IF;
END IF;
	
END $BODY$;


CREATE FUNCTION public.check_participant_participation()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN

IF NEW.role = 'participant' AND NEW.course_code IN (SELECT get_lab_activites()) THEN
	IF ((NEW.end_time - NEW.start_time)  <= (SELECT get_course_lab_hours(NEW.course_code))) THEN
		RETURN NEW;
	ELSE
		RAISE EXCEPTION 'Violation of person-independency constrains for participation, the "Person" exceeds lab-hours limit';
		RETURN NULL;
	END IF;
ELSE
		RETURN NEW;
	
END IF;
	
	
END $BODY$;


--trigger declarations

CREATE TRIGGER inspect_participant_participation
    BEFORE INSERT OR UPDATE 
    ON public."Participates"
    FOR EACH ROW
    EXECUTE PROCEDURE public.check_participant_participation();

CREATE TRIGGER inspect_responsible_participation
    BEFORE INSERT OR UPDATE 
    ON public."Participates"
    FOR EACH ROW
    EXECUTE PROCEDURE public.check_responsible_participation();