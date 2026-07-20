/*=============================================================
    TP - Gestión de Datos
    Sistema: FitChain
    Parte B.4 - VISTAS E INDICES
=============================================================*/

/*=============================================================
                    DashboardSucursal
=============================================================*/

CREATE OR REPLACE VIEW DashboardSucursal AS
SELECT
    s.idSucursal,
    s.nombre AS sucursal,

    /* Socios activos */
    (
        SELECT COUNT(*)
        FROM CONTRATACION_MEMBRESIA cm
        WHERE cm.estado = 'Activa'
    ) AS socios_activos,

    /* Ingresos del mes */
    (
        SELECT COALESCE(SUM(f.total),0)
        FROM FACTURA f
        WHERE DATE_TRUNC('month',f.fechaEmision)=DATE_TRUNC('month',CURRENT_DATE)
    ) AS ingresos_mes,

    /* Ocupación promedio */
    (
        SELECT ROUND(
            AVG((COALESCE(ins.cantidad,0)::numeric/h.capacidadMaxima)*100),
            2
        )
        FROM HORARIO_CLASE h
        LEFT JOIN
        (
            SELECT
                idHorario,
                COUNT(*) cantidad
            FROM INSCRIPCION
            WHERE estado='Inscripto'
            GROUP BY idHorario
        ) ins
        ON h.idHorario=ins.idHorario
    ) AS ocupacion_promedio,

    /* Equipos en mantenimiento de la sucursal */
    (
        SELECT COUNT(*)
        FROM MANTENIMIENTO m
        INNER JOIN EQUIPO e
            ON m.idEquipo = e.idEquipo
        INNER JOIN SALA sa
            ON e.idSala = sa.idSala
        WHERE sa.idSucursal = s.idSucursal
    ) AS equipos_en_mantenimiento

FROM SUCURSAL s;

SELECT * FROM DashboardSucursal;

/*=============================================================
                    AlertaMorosos
=============================================================*/

CREATE OR REPLACE VIEW AlertasMorosos AS
SELECT
    s.idSocio,
    s.nombre,
    s.apellido,
    f.idFactura,
    CURRENT_DATE - f.fechaEmision AS dias_atraso,
    f.total AS monto_adeudado
FROM FACTURA f
INNER JOIN SOCIO s
    ON f.idSocio = s.idSocio
LEFT JOIN PAGO p
    ON f.idFactura = p.idFactura
WHERE
    p.idPago IS NULL
    AND f.estado = 'Vencida';

SELECT * FROM AlertasMorosos;

/*=============================================================
             Consulta 1 – Índice idx_factura_fecha
=============================================================*/

EXPLAIN ANALYZE
SELECT *
FROM FACTURA
WHERE fechaEmision >= DATE '2026-06-01'
  AND fechaEmision <= DATE '2026-06-30';

/*=============================================================
             Consulta 2 – Índice idx_socio_dni
=============================================================*/

EXPLAIN ANALYZE
SELECT *
FROM SOCIO
WHERE dni = 40123456;

/*=============================================================
            Consulta 3 – Índice idx_horario_clase
=============================================================*/

EXPLAIN ANALYZE
SELECT *
FROM HORARIO_CLASE
WHERE idClase = 10
  AND diaSemana = 'Lunes'
ORDER BY horaInicio;