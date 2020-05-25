CREATE TRIGGER trigger_b_2_1
  AFTER INSERT
  ON "Participates"
EXECUTE PROCEDURE b_2_1_handle();