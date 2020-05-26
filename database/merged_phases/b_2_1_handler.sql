CREATE OR REPLACE FUNCTION b_2_1_handle()
  RETURNS trigger 
  language plpgsql AS
$$
BEGIN
    IF (NEW.role = 'participant') THEN
        UPDATE b_2_1
        SET avail_space = (SELECT part.room_id, part.course_code, (r.capacity - COUNT(part.amka)) as avl_space
                         FROM "Student" st, "Participates" part, "Semester" se, "Room" r
                         WHERE st.amka = part.amka AND se.semester_status = 'present' AND se.semester_id = part.serial_number AND r.room_id = part.room_id
                         GROUP BY part.room_id, part.course_code, r.capacity)
        FROM "Participates"
        WHERE OLD.room_id = NEW.room_id AND OLD.course_code = NEW.course_code AND NEW.start_time = OLD.start_time AND NEW.end_time = OLD.end_time AND
              NEW.weekday = OLD.weekday AND NEW.serial_number = '22';
    END IF;
    RETURN NULL;
END;
$$;