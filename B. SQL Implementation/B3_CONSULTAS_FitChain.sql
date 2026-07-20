/*=============================================================
    TP - Gestión de Datos
    Sistema: FitChain
    Parte B.3 - CONSULTAS
=============================================================*/

/*=============================================================
                    Q01
=============================================================*/

SELECT
    s.idSocio,
    s.nombre,
    s.apellido,
    s.ciudad,
    m.nombre AS membresia,
    cm.estado
FROM SOCIO s
INNER JOIN CONTRATACION_MEMBRESIA cm
    ON s.idSocio = cm.idSocio
INNER JOIN MEMBRESIA m
    ON cm.idMembresia = m.idMembresia
WHERE cm.estado = 'Activa'
  AND m.nombre IN ('Premium','VIP')
  AND s.ciudad IN ('San Miguel de Tucumán','Yerba Buena','Concepción','Aguilares')
ORDER BY s.apellido, s.nombre;


/*=============================================================
                    Q02
=============================================================*/

SELECT
    m.nombre AS membresia,
    COUNT(cm.idSocio) AS cantidad_socios
FROM CONTRATACION_MEMBRESIA cm
INNER JOIN MEMBRESIA m
    ON cm.idMembresia = m.idMembresia
GROUP BY m.nombre
ORDER BY m.nombre;


/*=============================================================
                    Q03
=============================================================*/

SELECT
    e.idEmpleado,
    e.nombre,
    e.apellido,
    e.cargo,
    c.tipo,
    c.institucion,
    c.fechaVencimiento
FROM EMPLEADO e
LEFT JOIN CERTIFICACION c
    ON e.idEmpleado = c.idEmpleado
WHERE e.cargo IN ('Profesor','Personal Trainer')
ORDER BY e.apellido, e.nombre;


/*=============================================================
                    Q04
=============================================================*/

SELECT
    c.idClase,
    c.nombre,
    COUNT(i.idInscripcion) AS inscriptos,
    h.capacidadMaxima,
    ROUND(COUNT(i.idInscripcion) * 100.0 / h.capacidadMaxima, 2) AS porcentaje_ocupacion
FROM CLASE c
JOIN HORARIO_CLASE h
    ON c.idClase = h.idClase
LEFT JOIN INSCRIPCION i
    ON h.idHorario = i.idHorario
    AND i.estado = 'Inscripto'
    AND i.fechaInscripcion >= CURRENT_DATE - INTERVAL '1 month'
GROUP BY
    c.idClase,
    c.nombre,
    h.capacidadMaxima
HAVING ROUND(COUNT(i.idInscripcion) * 100.0 / h.capacidadMaxima, 2) > 80
ORDER BY porcentaje_ocupacion DESC;


/*=============================================================
                    Q05
=============================================================*/

SELECT
    s.idSocio,
    s.nombre,
    s.apellido,
    COUNT(a.idInscripcion) AS asistencias
FROM ASISTENCIA a
INNER JOIN INSCRIPCION i
    ON a.idInscripcion = i.idInscripcion
INNER JOIN SOCIO s
    ON i.idSocio = s.idSocio
WHERE a.presente = TRUE
  AND a.fecha >= CURRENT_DATE - INTERVAL '3 months'
GROUP BY s.idSocio, s.nombre, s.apellido
ORDER BY asistencias DESC
LIMIT 5;


/*=============================================================
                    Q06
=============================================================*/

SELECT
    e.idEquipo,
    e.nombre,
    e.marca,
    MAX(m.fecha) AS ultimo_mantenimiento
FROM EQUIPO e
INNER JOIN MANTENIMIENTO m
    ON e.idEquipo = m.idEquipo
GROUP BY e.idEquipo, e.nombre, e.marca
HAVING MAX(m.fecha) <= CURRENT_DATE - INTERVAL '30 days'
ORDER BY ultimo_mantenimiento;


/*=============================================================
                    Q07
=============================================================*/

SELECT
    s.idSocio,
    s.nombre,
    s.apellido,
    f.idFactura,
    f.fechaEmision,
    f.total
FROM SOCIO s
INNER JOIN FACTURA f
    ON s.idSocio = f.idSocio
LEFT JOIN PAGO p
    ON f.idFactura = p.idFactura
WHERE f.estado = 'Vencida'
  AND f.fechaEmision <= CURRENT_DATE - INTERVAL '30 days'
  AND p.idPago IS NULL
ORDER BY f.fechaEmision;


/*=============================================================
                    Q08
=============================================================*/

SELECT
    e.idEmpleado,
    e.nombre,
    e.apellido,
    e.cargo,
    COUNT(DISTINCT a.idSucursal) AS sucursales
FROM EMPLEADO e
INNER JOIN ASIGNACION_EMPLEADO a
    ON e.idEmpleado = a.idEmpleado
GROUP BY
    e.idEmpleado,
    e.nombre,
    e.apellido,
    e.cargo
HAVING COUNT(DISTINCT a.idSucursal) > 1
ORDER BY sucursales DESC;


/*=============================================================
                    Q09
=============================================================*/

SELECT
    e.idEquipo,
    e.nombre,
    e.marca,
    MAX(m.fecha) AS ultimo_mantenimiento
FROM EQUIPO e
INNER JOIN MANTENIMIENTO m
    ON e.idEquipo = m.idEquipo
GROUP BY
    e.idEquipo,
    e.nombre,
    e.marca
HAVING MAX(m.fecha) < CURRENT_DATE - INTERVAL '6 months'
ORDER BY ultimo_mantenimiento;


/*=============================================================
                    Q010
=============================================================*/

SELECT
    c.nombre,
    COUNT(i.idInscripcion) AS total_inscriptos,
    DENSE_RANK() OVER (
        ORDER BY COUNT(i.idInscripcion) DESC
    ) AS ranking
FROM CLASE c
LEFT JOIN HORARIO_CLASE h
    ON c.idClase = h.idClase
LEFT JOIN INSCRIPCION i
    ON h.idHorario = i.idHorario
GROUP BY
    c.idClase,
    c.nombre
ORDER BY ranking, c.nombre;


/*=============================================================
                    Q011
=============================================================*/

SELECT
    s.idSocio,
    s.nombre,
    s.apellido
FROM SOCIO s
WHERE NOT EXISTS (
    SELECT 1
    FROM CLASE c
    WHERE NOT EXISTS (
        SELECT 1
        FROM HORARIO_CLASE h
        INNER JOIN INSCRIPCION i
            ON h.idHorario = i.idHorario
        INNER JOIN ASISTENCIA a
            ON i.idInscripcion = a.idInscripcion
        WHERE h.idClase = c.idClase
          AND i.idSocio = s.idSocio
          AND a.presente = TRUE
    )
)
ORDER BY s.apellido, s.nombre;


/*=============================================================
                    Q012
=============================================================*/

SELECT
    m.nombre AS membresia,
    DATE_TRUNC('month', f.fechaEmision) AS mes,
    COUNT(f.idFactura) AS cantidad_facturas,
    SUM(f.total) AS facturacion_total
FROM FACTURA f
INNER JOIN SOCIO s
    ON f.idSocio = s.idSocio
INNER JOIN CONTRATACION_MEMBRESIA cm
    ON s.idSocio = cm.idSocio
INNER JOIN MEMBRESIA m
    ON cm.idMembresia = m.idMembresia
GROUP BY
    m.nombre,
    DATE_TRUNC('month', f.fechaEmision)
ORDER BY
    mes,
    membresia;


/*=============================================================
                    Q013
=============================================================*/

SELECT
    e.idEquipo,
    e.nombre,
    e.marca,
    COUNT(m.idMantenimiento) AS cantidad_mantenimientos
FROM EQUIPO e
LEFT JOIN MANTENIMIENTO m
    ON e.idEquipo = m.idEquipo
GROUP BY
    e.idEquipo,
    e.nombre,
    e.marca
ORDER BY
    cantidad_mantenimientos DESC,
    e.nombre;


/*=============================================================
                    Q014
=============================================================*/

SELECT
    e.idEmpleado,
    e.nombre,
    e.apellido,
    COUNT(d.idHorario) AS clases_asignadas
FROM EMPLEADO e
LEFT JOIN DICTA_EN d
    ON e.idEmpleado = d.idEmpleado
WHERE e.cargo IN ('Profesor','Personal Trainer')
GROUP BY
    e.idEmpleado,
    e.nombre,
    e.apellido
ORDER BY
    clases_asignadas DESC,
    e.apellido;


/*=============================================================
                    Q015
=============================================================*/

SELECT
    s.idSocio,
    s.nombre,
    s.apellido,
    SUM(p.monto) AS total_pagado,
    DENSE_RANK() OVER (
        ORDER BY SUM(p.monto) DESC
    ) AS ranking
FROM SOCIO s
INNER JOIN FACTURA f
    ON s.idSocio = f.idSocio
INNER JOIN PAGO p
    ON f.idFactura = p.idFactura
GROUP BY
    s.idSocio,
    s.nombre,
    s.apellido
ORDER BY
    ranking,
    s.apellido;