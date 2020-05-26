
--trigger functions

CREATE FUNCTION public.check_activity_time_constrains()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$BEGIN

IF NEW.weekday < 6 AND NEW.weekday > 0 AND NEW.start_time >= 8 AND NEW.start_time <= 20 AND NEW.end_time >= 9 AND NEW.end_time <= 20 AND NEW.end_time > NEW.start_time THEN
	RETURN NEW;
ELSE 
	RAISE EXCEPTION 'Violation of Limits for "weekday" or "end/start_time"';
	RETURN NULL;
END IF;
	
END $BODY$;

CREATE FUNCTION public.check_activity_schedule_constrains()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN

IF NEW.room_id NOT IN (SELECT room_id FROM "LearningActivity" WHERE weekday = NEW.weekday AND start_time = NEW.start_time) THEN
	RETURN NEW;
ELSE 
	RAISE EXCEPTION 'Violation of room-independency constrains for activity, the "Room" is reserved';
	RETURN NULL;
END IF;
	
END $BODY$;

--trigger declarations

CREATE TRIGGER notify_on_illegal_activity_input
    BEFORE INSERT OR UPDATE 
    ON public."LearningActivity"
    FOR EACH ROW
    EXECUTE PROCEDURE public.check_activity_time_constrains();
    

CREATE TRIGGER notify_on_illegal_activity_sched
    BEFORE INSERT OR UPDATE 
    ON public."LearningActivity"
    FOR EACH ROW
    EXECUTE PROCEDURE public.check_activity_schedule_constrains();