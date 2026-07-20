/*=============================================================
    TP - Base de Datos
    Sistema: FitChain
    Parte B.1 - DDL
    Motor: PostgreSQL
=============================================================*/

--=============================================================
-- CREACIÓN DE LA BASE DE DATOS
--=============================================================

/*CREATE DATABASE FitChain;*/

-- Ejecutar el resto del script sobre la base FitChain
-- \c FitChain

/*=============================================================
                        TABLA SOCIO
=============================================================*/

CREATE TABLE SOCIO (

    idSocio SERIAL PRIMARY KEY,

    dni INTEGER NOT NULL UNIQUE,

    nombre VARCHAR(50) NOT NULL,

    apellido VARCHAR(50) NOT NULL,

    fechaNacimiento DATE NOT NULL,

    email VARCHAR(100) UNIQUE,

    calle VARCHAR(80),

    numero VARCHAR(10),

    ciudad VARCHAR(50),

    codigoPostal VARCHAR(10),

    contactoEmergencia VARCHAR(100),

    fechaAlta DATE NOT NULL DEFAULT CURRENT_DATE

);

/*=============================================================
                    TABLA TELEFONO_SOCIO
=============================================================*/

CREATE TABLE TELEFONO_SOCIO (

    idSocio INTEGER NOT NULL,

    telefono VARCHAR(20) NOT NULL,

    PRIMARY KEY (idSocio, telefono),

    CONSTRAINT fk_telefono_socio
        FOREIGN KEY (idSocio)
        REFERENCES SOCIO(idSocio)
        ON UPDATE CASCADE
        ON DELETE CASCADE

);

/*=============================================================
                    TABLA MEMBRESIA
=============================================================*/

CREATE TABLE MEMBRESIA (

    idMembresia SERIAL PRIMARY KEY,

    nombre VARCHAR(30) NOT NULL UNIQUE,

    precioMensual NUMERIC(10,2) NOT NULL
        CHECK(precioMensual > 0),

    descripcion TEXT,

    incluyePersonalTrainer BOOLEAN NOT NULL DEFAULT FALSE,

    clasesIncluidas INTEGER
        CHECK(clasesIncluidas >= 0)

);

/*=============================================================
            TABLA CONTRATACION_MEMBRESIA
=============================================================*/

CREATE TABLE CONTRATACION_MEMBRESIA (

    idContratacion SERIAL PRIMARY KEY,

    idSocio INTEGER NOT NULL,

    idMembresia INTEGER NOT NULL,

    fechaInicio DATE NOT NULL,

    fechaFin DATE,

    estado VARCHAR(20) NOT NULL
        CHECK (estado IN ('Activa','Suspendida','Finalizada')),

    CONSTRAINT chk_fechas_contratacion
        CHECK (
            fechaFin IS NULL
            OR
            fechaFin > fechaInicio
        ),

    CONSTRAINT fk_contratacion_socio
        FOREIGN KEY (idSocio)
        REFERENCES SOCIO(idSocio)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_contratacion_membresia
        FOREIGN KEY (idMembresia)
        REFERENCES MEMBRESIA(idMembresia)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

);

/*=============================================================
                    TABLA EMPLEADO
=============================================================*/

CREATE TABLE EMPLEADO (

    idEmpleado SERIAL PRIMARY KEY,

    dni INTEGER UNIQUE,

    nombre VARCHAR(50) NOT NULL,

    apellido VARCHAR(50) NOT NULL,

    cargo VARCHAR(30) NOT NULL,

    telefono VARCHAR(20),

    email VARCHAR(100) UNIQUE,

    fechaIngreso DATE NOT NULL,

    sueldoBase NUMERIC(12,2) NOT NULL
        CHECK(sueldoBase > 0)

);

/*=============================================================
                        TABLA CLASE
=============================================================*/

CREATE TABLE CLASE (

    idClase SERIAL PRIMARY KEY,

    nombre VARCHAR(50) NOT NULL,

    descripcion TEXT,

    intensidad VARCHAR(20),

    duracion INTEGER NOT NULL
        CHECK (duracion > 0)

);


/*=============================================================
                    TABLA HORARIO_CLASE
=============================================================*/

CREATE TABLE HORARIO_CLASE (

    idHorario SERIAL PRIMARY KEY,

    idClase INTEGER NOT NULL,

    diaSemana VARCHAR(15) NOT NULL,

    horaInicio TIME NOT NULL,

    horaFin TIME NOT NULL,

    capacidadMaxima INTEGER NOT NULL
        CHECK (capacidadMaxima > 0),

    CONSTRAINT chk_horario
        CHECK (horaFin > horaInicio),

    CONSTRAINT fk_horario_clase
        FOREIGN KEY (idClase)
        REFERENCES CLASE(idClase)
        ON UPDATE CASCADE
        ON DELETE CASCADE

);


/*=============================================================
                    TABLA INSCRIPCION
=============================================================*/

CREATE TABLE INSCRIPCION (

    idInscripcion SERIAL PRIMARY KEY,

    idSocio INTEGER NOT NULL,

    idHorario INTEGER NOT NULL,

    fechaInscripcion DATE NOT NULL
        DEFAULT CURRENT_DATE,

    estado VARCHAR(20) NOT NULL
        CHECK (estado IN ('Inscripto','Cancelado','ListaEspera')),

    listaEspera BOOLEAN DEFAULT FALSE,

    CONSTRAINT fk_inscripcion_socio
        FOREIGN KEY (idSocio)
        REFERENCES SOCIO(idSocio)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_inscripcion_horario
        FOREIGN KEY (idHorario)
        REFERENCES HORARIO_CLASE(idHorario)
        ON UPDATE CASCADE
        ON DELETE CASCADE

);


/*=============================================================
                    TABLA ASISTENCIA
=============================================================*/

CREATE TABLE ASISTENCIA (

    idAsistencia SERIAL PRIMARY KEY,

    idInscripcion INTEGER NOT NULL,

    fecha DATE NOT NULL,

    horaIngreso TIME,

    horaSalida TIME,

    presente BOOLEAN DEFAULT FALSE,

    CONSTRAINT chk_horas
        CHECK (
            horaSalida IS NULL
            OR horaIngreso IS NULL
            OR horaSalida > horaIngreso
        ),

    CONSTRAINT fk_asistencia_inscripcion
        FOREIGN KEY (idInscripcion)
        REFERENCES INSCRIPCION(idInscripcion)
        ON UPDATE CASCADE
        ON DELETE CASCADE

);


/*=============================================================
                    TABLA CERTIFICACION
=============================================================*/

CREATE TABLE CERTIFICACION (

    idCertificacion SERIAL PRIMARY KEY,

    idEmpleado INTEGER NOT NULL,

    tipo VARCHAR(50) NOT NULL,

    institucion VARCHAR(100) NOT NULL,

    fechaObtencion DATE NOT NULL,

    fechaVencimiento DATE,

    CONSTRAINT chk_certificacion
        CHECK (
            fechaVencimiento IS NULL
            OR fechaVencimiento > fechaObtencion
        ),

    CONSTRAINT fk_certificacion_empleado
        FOREIGN KEY (idEmpleado)
        REFERENCES EMPLEADO(idEmpleado)
        ON UPDATE CASCADE
        ON DELETE CASCADE

);

/*=============================================================
                    TABLA SUCURSAL
=============================================================*/

CREATE TABLE SUCURSAL (

    idSucursal SERIAL PRIMARY KEY,

    nombre VARCHAR(60) NOT NULL,

    direccion VARCHAR(120) NOT NULL,

    ciudad VARCHAR(50) NOT NULL,

    provincia VARCHAR(50) NOT NULL,

    horarioApertura TIME,

    horarioCierre TIME,

    CONSTRAINT chk_horario_sucursal
        CHECK (
            horarioCierre IS NULL
            OR horarioApertura IS NULL
            OR horarioCierre > horarioApertura
        )

);


/*=============================================================
                TABLA ASIGNACION_EMPLEADO
=============================================================*/

CREATE TABLE ASIGNACION_EMPLEADO (

    idAsignacion SERIAL PRIMARY KEY,

    idEmpleado INTEGER NOT NULL,

    idSucursal INTEGER NOT NULL,

    fechaInicio DATE NOT NULL,

    fechaFin DATE,

    estado VARCHAR(20),

    CONSTRAINT chk_fechas_asignacion
        CHECK (
            fechaFin IS NULL
            OR fechaFin > fechaInicio
        ),

    CONSTRAINT fk_asignacion_empleado
        FOREIGN KEY (idEmpleado)
        REFERENCES EMPLEADO(idEmpleado)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_asignacion_sucursal
        FOREIGN KEY (idSucursal)
        REFERENCES SUCURSAL(idSucursal)
        ON UPDATE CASCADE
        ON DELETE CASCADE

);


/*=============================================================
                        TABLA SALA
=============================================================*/

CREATE TABLE SALA (

    idSala SERIAL PRIMARY KEY,

    idSucursal INTEGER NOT NULL,

    nombre VARCHAR(50),

    tipo VARCHAR(40),

    capacidad INTEGER
        CHECK (capacidad > 0),

    CONSTRAINT fk_sala_sucursal
        FOREIGN KEY (idSucursal)
        REFERENCES SUCURSAL(idSucursal)
        ON UPDATE CASCADE
        ON DELETE CASCADE

);


/*=============================================================
                        TABLA EQUIPO
=============================================================*/

CREATE TABLE EQUIPO (

    idEquipo SERIAL PRIMARY KEY,

    idSala INTEGER NOT NULL,

    nombre VARCHAR(60),

    marca VARCHAR(40),

    modelo VARCHAR(40),

    fechaCompra DATE,

    estado VARCHAR(20),

    CONSTRAINT chk_estado_equipo
        CHECK (
            estado IN (
                'Disponible',
                'En uso',
                'En mantenimiento',
                'Fuera de servicio'
            )
        ),

    CONSTRAINT fk_equipo_sala
        FOREIGN KEY (idSala)
        REFERENCES SALA(idSala)
        ON UPDATE CASCADE
        ON DELETE CASCADE

);


/*=============================================================
                    TABLA MANTENIMIENTO
=============================================================*/

CREATE TABLE MANTENIMIENTO (

    idMantenimiento SERIAL PRIMARY KEY,

    idEquipo INTEGER NOT NULL,

    idEmpleado INTEGER NOT NULL,

    fecha DATE NOT NULL,

    tipo VARCHAR(30),

    descripcion TEXT,

    costo NUMERIC(10,2)
        CHECK (costo >= 0),

    CONSTRAINT fk_mantenimiento_equipo
        FOREIGN KEY (idEquipo)
        REFERENCES EQUIPO(idEquipo)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_mantenimiento_empleado
        FOREIGN KEY (idEmpleado)
        REFERENCES EMPLEADO(idEmpleado)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

);

/*=============================================================
                        TABLA FACTURA
=============================================================*/

CREATE TABLE FACTURA (

    idFactura SERIAL PRIMARY KEY,

    idSocio INTEGER NOT NULL,

    fechaEmision DATE NOT NULL
        DEFAULT CURRENT_DATE,

    total NUMERIC(10,2) NOT NULL
        CHECK (total > 0),

    estado VARCHAR(20) NOT NULL
        CHECK (
            estado IN (
                'Pendiente',
                'Pagada',
                'Vencida',
                'Anulada'
            )
        ),

    CONSTRAINT fk_factura_socio
        FOREIGN KEY (idSocio)
        REFERENCES SOCIO(idSocio)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

);


/*=============================================================
                    TABLA DETALLE_FACTURA
=============================================================*/

CREATE TABLE DETALLE_FACTURA (

    idFactura INTEGER NOT NULL,

    nroDetalle INTEGER NOT NULL,

    concepto VARCHAR(100) NOT NULL,

    cantidad INTEGER NOT NULL
        CHECK (cantidad > 0),

    precioUnitario NUMERIC(10,2) NOT NULL
        CHECK (precioUnitario > 0),

    PRIMARY KEY (idFactura, nroDetalle),

    CONSTRAINT fk_detalle_factura
        FOREIGN KEY (idFactura)
        REFERENCES FACTURA(idFactura)
        ON UPDATE CASCADE
        ON DELETE CASCADE

);


/*=============================================================
                        TABLA PAGO
=============================================================*/

CREATE TABLE PAGO (

    idPago SERIAL PRIMARY KEY,

    idFactura INTEGER NOT NULL,

    fechaPago DATE NOT NULL
        DEFAULT CURRENT_DATE,

    monto NUMERIC(10,2) NOT NULL
        CHECK (monto > 0),

    medioPago VARCHAR(30) NOT NULL
        CHECK (
            medioPago IN (
                'Efectivo',
                'Debito',
                'Credito',
                'Transferencia',
                'MercadoPago'
            )
        ),

    referencia VARCHAR(100),

    estado VARCHAR(20)
        DEFAULT 'Confirmado'
        CHECK (
            estado IN (
                'Pendiente',
                'Confirmado',
                'Rechazado'
            )
        ),

    CONSTRAINT fk_pago_factura
        FOREIGN KEY (idFactura)
        REFERENCES FACTURA(idFactura)
        ON UPDATE CASCADE
        ON DELETE CASCADE

);

/*=============================================================
                        TABLA RUTINA
=============================================================*/

CREATE TABLE RUTINA (

    idRutina SERIAL PRIMARY KEY,

    idSocio INTEGER NOT NULL,

    nombre VARCHAR(80),

    objetivo VARCHAR(150),

    fechaCreacion DATE DEFAULT CURRENT_DATE,

    observaciones TEXT,

    CONSTRAINT fk_rutina_socio
        FOREIGN KEY (idSocio)
        REFERENCES SOCIO(idSocio)
        ON UPDATE CASCADE
        ON DELETE CASCADE

);


/*=============================================================
                TABLA PROGRESO_FISICO
=============================================================*/

CREATE TABLE PROGRESO_FISICO (

    idRegistro SERIAL PRIMARY KEY,

    idSocio INTEGER NOT NULL,

    fecha DATE NOT NULL,

    peso NUMERIC(5,2)
        CHECK (peso > 0),

    medidas TEXT,

    porcentajeGrasa NUMERIC(5,2)
        CHECK (porcentajeGrasa BETWEEN 0 AND 100),

    marcasPersonales TEXT,

    CONSTRAINT fk_progreso_socio
        FOREIGN KEY (idSocio)
        REFERENCES SOCIO(idSocio)
        ON UPDATE CASCADE
        ON DELETE CASCADE

);


/*=============================================================
                    TABLA DICTA_EN
=============================================================*/

CREATE TABLE DICTA_EN (

    idEmpleado INTEGER NOT NULL,

    idHorario INTEGER NOT NULL,

    idSucursal INTEGER NOT NULL,

    PRIMARY KEY (
        idEmpleado,
        idHorario,
        idSucursal
    ),

    CONSTRAINT fk_dicta_empleado
        FOREIGN KEY (idEmpleado)
        REFERENCES EMPLEADO(idEmpleado)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_dicta_horario
        FOREIGN KEY (idHorario)
        REFERENCES HORARIO_CLASE(idHorario)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_dicta_sucursal
        FOREIGN KEY (idSucursal)
        REFERENCES SUCURSAL(idSucursal)
        ON UPDATE CASCADE
        ON DELETE CASCADE

);


/*=============================================================
                    ÍNDICES ESTRATÉGICOS
=============================================================*/
-- Búsqueda rápida de socios por DNI
CREATE INDEX idx_socio_dni
ON SOCIO(dni);

-- Consultas frecuentes de facturación por fecha
CREATE INDEX idx_factura_fecha
ON FACTURA(fechaEmision);

-- Consultas de clases por horario
CREATE INDEX idx_horario_clase
ON HORARIO_CLASE(idClase, diaSemana, horaInicio);


