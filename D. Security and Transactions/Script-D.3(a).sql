BEGIN;

INSERT INTO factura (id, id_socio, fecha_emision, total) 
VALUES (9001, 1, CURRENT_DATE, 15000.00);

INSERT INTO detalle_factura (id, factura_id, concepto, subtotal) 
VALUES (1, 9001, 'Cuota Mensual FitChain', 15000.00);

UPDATE membresia 
SET estado = 'Activa', 
    fecha_fin = CURRENT_DATE + INTERVAL '1 month'
WHERE id = 1;

COMMIT;


