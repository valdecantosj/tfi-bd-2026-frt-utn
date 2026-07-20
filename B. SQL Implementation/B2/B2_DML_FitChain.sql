/*=============================================================
    TP - Gestión de Datos
    Sistema: FitChain
    Parte B.2 - DML
=============================================================*/


/*=============================================================
                    MEMBRESIAS
=============================================================*/

INSERT INTO MEMBRESIA
(nombre, precioMensual, descripcion, incluyePersonalTrainer, clasesIncluidas)
VALUES

('Basica',15000,'Acceso general al gimnasio',FALSE,10),

('Premium',25000,'Acceso a todas las clases',FALSE,999),

('VIP',40000,'Incluye Personal Trainer',TRUE,999);



/*=============================================================
                    SUCURSALES
=============================================================*/

INSERT INTO SUCURSAL
(nombre,direccion,ciudad,provincia,horarioApertura,horarioCierre)

VALUES

('Centro','San Martin 250','San Miguel de Tucuman','Tucuman','07:00','22:00'),

('Yerba Buena','Aconquija 1500','Yerba Buena','Tucuman','07:00','22:00'),

('Tafí Viejo','Av. Alem 450','Tafí Viejo','Tucuman','07:00','22:00'),

('Salta Centro','Caseros 800','Salta','Salta','07:00','22:00'),

('Orán','Belgrano 250','Orán','Salta','07:00','22:00'),

('Jujuy Centro','Patricias Argentinas 100','San Salvador de Jujuy','Jujuy','07:00','22:00'),

('Palpalá','Av. Libertad 300','Palpalá','Jujuy','07:00','22:00'),

('Catamarca Centro','Sarmiento 350','San Fernando del Valle','Catamarca','07:00','22:00'),

('Belén','Rivadavia 250','Belén','Catamarca','07:00','22:00'),

('La Banda','Av. Besares 800','La Banda','Santiago del Estero','07:00','22:00'),

('Santiago Centro','Independencia 420','Santiago del Estero','Santiago del Estero','07:00','22:00'),

('Concepción','España 120','Concepción','Tucuman','07:00','22:00'),

('Aguilares','Mitre 450','Aguilares','Tucuman','07:00','22:00'),

('Metán','9 de Julio 780','Metán','Salta','07:00','22:00'),

('Perico','Belgrano 510','Perico','Jujuy','07:00','22:00');


/*=============================================================
                        SOCIOS
=============================================================*/

INSERT INTO SOCIO
(dni,nombre,apellido,fechaNacimiento,email,calle,numero,ciudad,codigoPostal,contactoEmergencia)
VALUES

(40123456,'Juan','Pérez','1998-03-12','juan.perez@gmail.com','San Martín','250','San Miguel de Tucumán','4000','Carlos Pérez'),

(40234567,'María','Gómez','1997-07-22','maria.gomez@gmail.com','25 de Mayo','1250','Yerba Buena','4107','Laura Gómez'),

(40345678,'Lucas','Rodríguez','1995-11-10','lucas.rodriguez@gmail.com','Av. Mate de Luna','845','San Miguel de Tucumán','4000','Ana Rodríguez'),

(40456789,'Sofía','López','1999-01-28','sofia.lopez@gmail.com','Rivadavia','542','Concepción','4146','Jorge López'),

(40567890,'Martín','Fernández','1996-04-19','martin.fernandez@gmail.com','Belgrano','630','Aguilares','4152','Claudia Fernández'),

(40678901,'Valentina','Martínez','1998-06-08','valentina.martinez@gmail.com','Sarmiento','455','Salta','4400','Diego Martínez'),

(40789012,'Tomás','Sánchez','1994-09-14','tomas.sanchez@gmail.com','Caseros','720','Salta','4400','María Sánchez'),

(40890123,'Julieta','Romero','1997-12-03','julieta.romero@gmail.com','España','315','San Salvador de Jujuy','4600','Pablo Romero'),

(40901234,'Benjamín','Torres','1995-08-18','benjamin.torres@gmail.com','Patricias Argentinas','800','Palpalá','4612','Laura Torres'),

(41012345,'Camila','Ruiz','1999-05-30','camila.ruiz@gmail.com','Mitre','980','Metán','4440','José Ruiz'),

(41123456,'Nicolás','Acosta','1996-02-16','nicolas.acosta@gmail.com','Av. Alem','1120','San Miguel de Tucumán','4000','Andrea Acosta'),

(41234567,'Florencia','Herrera','1998-10-21','florencia.herrera@gmail.com','Lavalle','95','Yerba Buena','4107','Miguel Herrera'),

(41345678,'Agustín','Castro','1995-07-09','agustin.castro@gmail.com','Buenos Aires','760','Concepción','4146','Patricia Castro'),

(41456789,'Milagros','Silva','1997-04-27','milagros.silva@gmail.com','9 de Julio','340','Aguilares','4152','Diego Silva'),

(41567890,'Franco','Molina','1994-11-01','franco.molina@gmail.com','Colón','510','San Miguel de Tucumán','4000','Norma Molina'),

(41678901,'Lucía','Ortiz','1999-03-25','lucia.ortiz@gmail.com','Junín','670','Salta','4400','Daniel Ortiz'),

(41789012,'Mateo','Navarro','1996-12-15','mateo.navarro@gmail.com','Alvarado','420','Orán','4530','Silvia Navarro'),

(41890123,'Martina','Ramos','1998-01-18','martina.ramos@gmail.com','Dean Funes','385','San Salvador de Jujuy','4600','Mario Ramos'),

(41901234,'Thiago','Morales','1995-06-11','thiago.morales@gmail.com','Belgrano','240','Perico','4608','Elena Morales'),

(42012345,'Emma','Suárez','1997-09-07','emma.suarez@gmail.com','Sarmiento','870','Catamarca','4700','Ricardo Suárez'),

(42123456,'Joaquín','Vega','1996-08-12','joaquin.vega@gmail.com','Esquiú','390','Belén','4750','María Vega'),

(42234567,'Catalina','Reyes','1999-04-20','catalina.reyes@gmail.com','Roca','150','La Banda','4300','Hugo Reyes'),

(42345678,'Facundo','Medina','1995-02-09','facundo.medina@gmail.com','Independencia','610','Santiago del Estero','4200','Sandra Medina'),

(42456789,'Victoria','Rojas','1998-11-13','victoria.rojas@gmail.com','Urquiza','540','San Miguel de Tucumán','4000','Carlos Rojas'),

(42567890,'Santiago','Cabrera','1994-07-30','santiago.cabrera@gmail.com','24 de Septiembre','470','Yerba Buena','4107','Paula Cabrera'),

(42678901,'Abril','Paz','1997-05-17','abril.paz@gmail.com','San Lorenzo','260','Concepción','4146','Raúl Paz'),

(42789012,'Bautista','Ibarra','1998-03-08','bautista.ibarra@gmail.com','Moreno','750','Salta','4400','Claudia Ibarra'),

(42890123,'Renata','Campos','1996-10-26','renata.campos@gmail.com','Catamarca','990','San Salvador de Jujuy','4600','Luis Campos'),

(42901234,'Ignacio','Peralta','1995-01-14','ignacio.peralta@gmail.com','Ayacucho','360','Aguilares','4152','Patricia Peralta'),

(43012345,'Olivia','Benítez','1999-08-22','olivia.benitez@gmail.com','Lamadrid','845','San Miguel de Tucumán','4000','Mariano Benítez');

/*=============================================================
                    TELEFONOS
=============================================================*/

INSERT INTO TELEFONO_SOCIO

(idSocio,telefono)

SELECT

idSocio,

'3815'||LPAD(idSocio::text,6,'0')

FROM SOCIO;


/*=============================================================
                    EMPLEADOS
=============================================================*/

INSERT INTO EMPLEADO
(dni,nombre,apellido,cargo,telefono,email,fechaIngreso,sueldoBase)

VALUES

(42000001,'Carlos','García','Recepcionista','3816000001','carlos.garcia@fitchain.com','2022-01-10',320000),

(42000002,'Lucía','Fernández','Recepcionista','3816000002','lucia.fernandez@fitchain.com','2022-02-15',320000),

(42000003,'Matías','López','Recepcionista','3816000003','matias.lopez@fitchain.com','2022-03-20',320000),

(42000004,'Martina','Pérez','Profesor','3816000004','martina.perez@fitchain.com','2021-08-10',410000),

(42000005,'Juan','Suárez','Profesor','3816000005','juan.suarez@fitchain.com','2020-05-11',420000),

(42000006,'Camila','Morales','Profesor','3816000006','camila.morales@fitchain.com','2021-04-25',415000),

(42000007,'Agustín','Romero','Profesor','3816000007','agustin.romero@fitchain.com','2023-01-10',405000),

(42000008,'Valentina','Rojas','Profesor','3816000008','valentina.rojas@fitchain.com','2022-06-18',410000),

(42000009,'Tomás','Acosta','Personal Trainer','3816000009','tomas.acosta@fitchain.com','2020-10-01',480000),

(42000010,'Julieta','Herrera','Personal Trainer','3816000010','julieta.herrera@fitchain.com','2021-09-12',480000),

(42000011,'Nicolás','Castro','Gerente','3816000011','nicolas.castro@fitchain.com','2019-04-10',650000),

(42000012,'Florencia','Vega','Gerente','3816000012','florencia.vega@fitchain.com','2018-07-05',650000),

(42000013,'Diego','Silva','Mantenimiento','3816000013','diego.silva@fitchain.com','2022-11-01',340000),

(42000014,'Paula','Benítez','Mantenimiento','3816000014','paula.benitez@fitchain.com','2023-01-16',340000),

(42000015,'Federico','Navarro','Mantenimiento','3816000015','federico.navarro@fitchain.com','2021-02-28',340000);


/*=============================================================
                    CERTIFICACIONES
=============================================================*/
INSERT INTO CERTIFICACION
(idEmpleado,tipo,institucion,fechaObtencion,fechaVencimiento)

SELECT

idEmpleado,

CASE
    WHEN cargo='Profesor' THEN 'Instructor Fitness'
    WHEN cargo='Personal Trainer' THEN 'Personal Trainer'
    ELSE 'Capacitación General'
END,

'Instituto Nacional del Deporte',

DATE '2023-01-01',

DATE '2028-01-01'

FROM EMPLEADO

WHERE cargo IN ('Profesor','Personal Trainer');


/*=============================================================
                ASIGNACION DE EMPLEADOS
=============================================================*/
INSERT INTO ASIGNACION_EMPLEADO
(idEmpleado,idSucursal,fechaInicio,estado)

SELECT

idEmpleado,

((idEmpleado-1)%15)+1,

DATE '2024-01-01',

'Activa'

FROM EMPLEADO;


/*=============================================================
                        CLASES
=============================================================*/

INSERT INTO CLASE
(nombre,descripcion,intensidad,duracion)

SELECT

CASE ((g-1)%7)

    WHEN 0 THEN 'Spinning'
    WHEN 1 THEN 'Yoga'
    WHEN 2 THEN 'CrossFit'
    WHEN 3 THEN 'Funcional'
    WHEN 4 THEN 'Pilates'
    WHEN 5 THEN 'Zumba'
    ELSE 'Boxeo'

END,

CASE ((g-1)%7)

    WHEN 0 THEN 'Entrenamiento cardiovascular en bicicleta fija.'
    WHEN 1 THEN 'Clase enfocada en flexibilidad y relajación.'
    WHEN 2 THEN 'Entrenamiento funcional de alta intensidad.'
    WHEN 3 THEN 'Ejercicios de fuerza y resistencia.'
    WHEN 4 THEN 'Mejora de postura, equilibrio y movilidad.'
    WHEN 5 THEN 'Actividad aeróbica con música.'
    ELSE 'Entrenamiento de boxeo recreativo.'

END,

CASE

    WHEN (g%3)=0 THEN 'Alta'
    WHEN (g%3)=1 THEN 'Media'
    ELSE 'Baja'

END,

CASE

    WHEN (g%4)=0 THEN 45
    WHEN (g%4)=1 THEN 60
    WHEN (g%4)=2 THEN 75
    ELSE 90

END

FROM generate_series(1,50) g;


/*=============================================================
                    HORARIOS
=============================================================*/

INSERT INTO HORARIO_CLASE
(idClase,diaSemana,horaInicio,horaFin,capacidadMaxima)

SELECT

idClase,

CASE ((idClase-1)%6)

    WHEN 0 THEN 'Lunes'
    WHEN 1 THEN 'Martes'
    WHEN 2 THEN 'Miércoles'
    WHEN 3 THEN 'Jueves'
    WHEN 4 THEN 'Viernes'
    ELSE 'Sábado'

END,

CASE ((idClase-1)%4)

    WHEN 0 THEN TIME '08:00'
    WHEN 1 THEN TIME '10:00'
    WHEN 2 THEN TIME '17:00'
    ELSE TIME '19:00'

END,

CASE ((idClase-1)%4)

    WHEN 0 THEN TIME '09:00'
    WHEN 1 THEN TIME '11:00'
    WHEN 2 THEN TIME '18:00'
    ELSE TIME '20:00'

END,

CASE

    WHEN (idClase%3)=0 THEN 20
    WHEN (idClase%3)=1 THEN 25
    ELSE 30

END

FROM CLASE;


/*=============================================================
                    INSCRIPCIONES
=============================================================*/

INSERT INTO INSCRIPCION
(idSocio,idHorario,fechaInscripcion,estado,listaEspera)

SELECT

((g-1)%30)+1,

((g-1)%50)+1,

CURRENT_DATE-(g%90),

CASE
    WHEN (g%15)=0 THEN 'ListaEspera'
    WHEN (g%10)=0 THEN 'Cancelado'
    ELSE 'Inscripto'
END,

(g%15)=0

FROM generate_series(1,200) g;


/*=============================================================
                    ASISTENCIAS
=============================================================*/

INSERT INTO ASISTENCIA
(idInscripcion,fecha,horaIngreso,horaSalida,presente)

SELECT

idInscripcion,

CURRENT_DATE-(idInscripcion%90),

TIME '08:00',

TIME '09:00',

(idInscripcion%5)<>0

FROM INSCRIPCION;


/*=============================================================
                        SALAS
=============================================================*/

INSERT INTO SALA
(idSucursal,nombre,tipo,capacidad)

SELECT

((g-1)%15)+1,

CASE ((g-1)%4)

    WHEN 0 THEN 'Sala de Musculación'
    WHEN 1 THEN 'Sala de Cardio'
    WHEN 2 THEN 'Sala Funcional'
    ELSE 'Sala de Pilates'

END,

CASE ((g-1)%4)

    WHEN 0 THEN 'Musculacion'
    WHEN 1 THEN 'Cardio'
    WHEN 2 THEN 'Funcional'
    ELSE 'Pilates'

END,

CASE

    WHEN (g%3)=0 THEN 20
    WHEN (g%3)=1 THEN 25
    ELSE 30

END

FROM generate_series(1,30) g;


/*=============================================================
                        EQUIPOS
=============================================================*/

INSERT INTO EQUIPO
(idSala,nombre,marca,modelo,fechaCompra,estado)

SELECT

((g-1)%30)+1,

CASE ((g-1)%6)

    WHEN 0 THEN 'Cinta de correr'
    WHEN 1 THEN 'Bicicleta fija'
    WHEN 2 THEN 'Banco olímpico'
    WHEN 3 THEN 'Elíptica'
    WHEN 4 THEN 'Rack de sentadillas'
    ELSE 'Juego de mancuernas'

END,

CASE ((g-1)%4)

    WHEN 0 THEN 'Technogym'
    WHEN 1 THEN 'Life Fitness'
    WHEN 2 THEN 'Body Solid'
    ELSE 'BH Fitness'

END,

'Serie '||LPAD(g::text,3,'0'),

CURRENT_DATE-(g*45),

CASE

    WHEN (g%15)=0 THEN 'Fuera de servicio'
    WHEN (g%7)=0 THEN 'En mantenimiento'
    ELSE 'Disponible'

END

FROM generate_series(1,90) g;


/*=============================================================
                    MANTENIMIENTOS
=============================================================*/

INSERT INTO MANTENIMIENTO
(idEquipo,idEmpleado,fecha,tipo,descripcion,costo)

SELECT

((g-1)%90)+1,

13+((g-1)%3),

CURRENT_DATE-(g*8),

CASE

    WHEN (g%2)=0 THEN 'Preventivo'
    ELSE 'Correctivo'

END,

CASE

    WHEN (g%2)=0 THEN 'Mantenimiento preventivo programado.'
    ELSE 'Reemplazo de piezas por desgaste.'

END,

6000+(g*300)

FROM generate_series(1,45) g;


/*=============================================================
                        FACTURAS
=============================================================*/

INSERT INTO FACTURA
(idSocio,fechaEmision,total,estado)

SELECT

((g-1)%30)+1,

CURRENT_DATE-(g%180),

CASE
    WHEN (g%3)=0 THEN 15000
    WHEN (g%3)=1 THEN 25000
    ELSE 40000
END,

CASE
    WHEN (g%10)=0 THEN 'Vencida'
    WHEN (g%15)=0 THEN 'Pendiente'
    ELSE 'Pagada'
END

FROM generate_series(1,100) g;


/*=============================================================
                    DETALLE FACTURA
=============================================================*/

INSERT INTO DETALLE_FACTURA
(idFactura,nroDetalle,concepto,cantidad,precioUnitario)

SELECT

idFactura,

1,

'Membresía mensual',

1,

total

FROM FACTURA;


/*=============================================================
                        PAGOS
=============================================================*/

INSERT INTO PAGO
(idFactura,fechaPago,monto,medioPago,referencia,estado)

SELECT

idFactura,

fechaEmision+1,

total,

CASE (idFactura%5)

    WHEN 0 THEN 'Efectivo'
    WHEN 1 THEN 'Debito'
    WHEN 2 THEN 'Credito'
    WHEN 3 THEN 'Transferencia'
    ELSE 'MercadoPago'

END,

'PAGO-'||LPAD(idFactura::text,5,'0'),

'Confirmado'

FROM FACTURA

WHERE estado='Pagada';


/*=============================================================
                        RUTINAS
=============================================================*/

INSERT INTO RUTINA
(idSocio,nombre,objetivo,fechaCreacion,observaciones)

SELECT

idSocio,

CASE (idSocio%4)

    WHEN 0 THEN 'Hipertrofia'
    WHEN 1 THEN 'Descenso de peso'
    WHEN 2 THEN 'Resistencia'
    ELSE 'Preparación física'

END,

CASE (idSocio%4)

    WHEN 0 THEN 'Aumentar masa muscular'
    WHEN 1 THEN 'Reducir porcentaje graso'
    WHEN 2 THEN 'Mejorar resistencia cardiovascular'
    ELSE 'Mejorar rendimiento deportivo'

END,

CURRENT_DATE-(idSocio*5),

'Plan personalizado por entrenador.'

FROM SOCIO;


/*=============================================================
                PROGRESO FISICO
=============================================================*/

INSERT INTO PROGRESO_FISICO
(idSocio,fecha,peso,medidas,porcentajeGrasa,marcasPersonales)

SELECT

idSocio,

CURRENT_DATE-(idSocio*3),

60+(idSocio*0.9),

'Pecho:100 Cintura:80 Cadera:95',

15+(idSocio%12),

'Press banca: '||(70+idSocio)||' kg'

FROM SOCIO;


/*=============================================================
                    DICTA_EN
=============================================================*/

INSERT INTO DICTA_EN
(idEmpleado,idHorario,idSucursal)

SELECT

a.idEmpleado,

((ROW_NUMBER() OVER())-1)%50+1,

a.idSucursal

FROM ASIGNACION_EMPLEADO a

JOIN EMPLEADO e
ON e.idEmpleado=a.idEmpleado

WHERE e.cargo IN ('Profesor','Personal Trainer');


/*=============================================================
                CONTRATACION DE MEMBRESIAS
=============================================================*/

INSERT INTO CONTRATACION_MEMBRESIA
(idSocio,idMembresia,fechaInicio,fechaFin,estado)

SELECT

idSocio,

CASE
    WHEN idSocio<=10 THEN 1
    WHEN idSocio<=20 THEN 2
    ELSE 3
END,

CURRENT_DATE-(idSocio*30),

CASE
    WHEN idSocio%10=0 THEN CURRENT_DATE-10
    ELSE NULL
END,

CASE
    WHEN idSocio%10=0 THEN 'Finalizada'
    ELSE 'Activa'
END

FROM SOCIO;


/*=============================================================
        AJUSTES PARA CONSULTAS B.3 (DATOS DE PRUEBA)
=============================================================*/

INSERT INTO ASIGNACION_EMPLEADO
(idEmpleado,idSucursal,fechaInicio,estado)
VALUES
(4,2,'2025-01-01','Activa'),
(4,3,'2025-01-01','Activa'),
(5,4,'2025-01-01','Activa'),
(9,5,'2025-01-01','Activa');

----------------------------------------------------------

INSERT INTO INSCRIPCION
(idSocio,idHorario,fechaInscripcion,estado,listaEspera)
VALUES
(1,1,CURRENT_DATE,'Inscripto',FALSE),
(2,1,CURRENT_DATE,'Inscripto',FALSE),
(3,1,CURRENT_DATE,'Inscripto',FALSE),
(4,1,CURRENT_DATE,'Inscripto',FALSE),
(5,1,CURRENT_DATE,'Inscripto',FALSE),

(6,2,CURRENT_DATE,'Inscripto',FALSE),
(7,2,CURRENT_DATE,'Inscripto',FALSE),
(8,2,CURRENT_DATE,'Inscripto',FALSE),

(9,3,CURRENT_DATE,'Inscripto',FALSE),
(10,3,CURRENT_DATE,'Inscripto',FALSE);

-----------------------------------------------

INSERT INTO ASISTENCIA
(idInscripcion,fecha,horaIngreso,horaSalida,presente)

SELECT

idInscripcion,

CURRENT_DATE,

TIME '08:00',

TIME '09:00',

TRUE

FROM INSCRIPCION

WHERE idInscripcion>200;

-------------------------------------------------

INSERT INTO INSCRIPCION
(idSocio,idHorario,fechaInscripcion,estado,listaEspera)
VALUES

(11,1,CURRENT_DATE,'Inscripto',FALSE),
(12,1,CURRENT_DATE,'Inscripto',FALSE),
(13,1,CURRENT_DATE,'Inscripto',FALSE),
(14,1,CURRENT_DATE,'Inscripto',FALSE),
(15,1,CURRENT_DATE,'Inscripto',FALSE),
(16,1,CURRENT_DATE,'Inscripto',FALSE),
(17,1,CURRENT_DATE,'Inscripto',FALSE),
(18,1,CURRENT_DATE,'Inscripto',FALSE);


INSERT INTO ASISTENCIA
(idInscripcion,fecha,horaIngreso,horaSalida,presente)

SELECT

idInscripcion,

CURRENT_DATE,

TIME '08:00',

TIME '09:00',

TRUE

FROM INSCRIPCION

WHERE idInscripcion>210;

----------------------------------------

INSERT INTO INSCRIPCION
(idSocio,idHorario,fechaInscripcion,estado,listaEspera)
VALUES
(19,1,CURRENT_DATE,'Inscripto',FALSE),
(20,1,CURRENT_DATE,'Inscripto',FALSE),
(21,1,CURRENT_DATE,'Inscripto',FALSE),
(22,1,CURRENT_DATE,'Inscripto',FALSE);
(23,1,CURRENT_DATE,'Inscripto',FALSE),
(24,1,CURRENT_DATE,'Inscripto',FALSE);

INSERT INTO ASISTENCIA
(idInscripcion,fecha,horaIngreso,horaSalida,presente)
SELECT
    idInscripcion,
    CURRENT_DATE,
    TIME '08:00',
    TIME '09:00',
    TRUE
FROM INSCRIPCION
WHERE idInscripcion > (
    SELECT MAX(idInscripcion) - 4
    FROM INSCRIPCION
);