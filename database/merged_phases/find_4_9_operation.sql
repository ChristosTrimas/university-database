CREATE OR REPLACE FUNCTION public.find_4_9_operation()
    RETURNS TABLE(room_code integer, day integer, s_time integer, e_time integer) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $$
BEGIN 
	RETURN QUERY (SELECT  room_id, weekday, min(start_time), max(end_time) FROM "LearningActivity" GROUP BY room_id,	weekday ORDER BY room_id ASC);
END;
$$