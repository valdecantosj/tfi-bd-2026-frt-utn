CREATE TABLE auditoria_financiera (
    id SERIAL PRIMARY KEY,
    tabla_afectada VARCHAR(50),
    operacion VARCHAR(10), 
    registro_id INT,       
    fecha_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_db VARCHAR(50) DEFAULT CURRENT_USER
);

CREATE OR REPLACE FUNCTION registrar_auditoria()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'INSERT') THEN
        INSERT INTO auditoria_financiera (tabla_afectada, operacion, registro_id)
        VALUES (TG_TABLE_NAME, 'INSERT', NEW.id);
        RETURN NEW;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO auditoria_financiera (tabla_afectada, operacion, registro_id)
        VALUES (TG_TABLE_NAME, 'UPDATE', NEW.id);
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO auditoria_financiera (tabla_afectada, operacion, registro_id)
        VALUES (TG_TABLE_NAME, 'DELETE', OLD.id);
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_auditoria_factura
AFTER INSERT OR UPDATE OR DELETE ON factura
FOR EACH ROW EXECUTE FUNCTION registrar_auditoria();

CREATE TRIGGER trg_auditoria_pago
AFTER INSERT OR UPDATE OR DELETE ON pago
FOR EACH ROW EXECUTE FUNCTION registrar_auditoria();

