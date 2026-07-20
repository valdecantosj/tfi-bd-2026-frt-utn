
CREATE ROLE admin_sistema;
CREATE ROLE gerente_sucursal;
CREATE ROLE recepcionista;
CREATE ROLE profesor;
CREATE ROLE socio_app;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin_sistema;

GRANT SELECT, INSERT, UPDATE, DELETE ON EMPLEADO, SUCURSAL, FACTURA, PAGO TO gerente_sucursal;

GRANT SELECT, INSERT, UPDATE ON socio, membresia, factura, pago TO recepcionista;
REVOKE DELETE ON socio, membresia, factura, pago FROM recepcionista; 

GRANT SELECT ON socio, clase, horario_clase TO profesor;

GRANT SELECT ON clase, horario_clase TO socio_app;




