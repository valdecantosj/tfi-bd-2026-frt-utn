
AR1. Socios con membresía VIP de la sucursal "Centro".
$\pi_{socio\_nombre} \left( \sigma_{tipo\_membresia = 'VIP' \,\wedge\, sucursal = 'Centro'} \left( SOCIO \bowtie \text{CONTRATACIÓN\_MEMBRESÍA} \bowtie \text{MEMBRESÍA} \bowtie \text{SUCURSAL} \right) \right)$

AR2. Nombre y apellido de todos los profesores que dictan Spinning.
$\pi_{empleado\_nombre} \left( \sigma_{nombre = 'Spinning'} \left( EMPLEADO \bowtie CLASE \right) \right)$


AR3. Sucursales que NO tienen clases de Yoga.
$\pi_{sucursal}(SUCURSAL) - \pi_{sucursal} \left( \sigma_{nombre = 'Yoga'} \left( SUCURSAL \bowtie \text{HORARIO\_CLASE} \bowtie CLASE \right) \right)$


AR4. Socios inscriptos en TODAS las clases de CrossFit.
Sean:
$R = \pi_{socio\_dni, idClase} \left( \text{INSCRIPCIÓN} \bowtie \sigma_{nombre = 'CrossFit'}(CLASE) \right)$
$S = \pi_{idClase} \left( \sigma_{nombre = 'CrossFit'}(CLASE) \right)$
Entonces:
$\pi_{socio\_nombre} \left( SOCIO \bowtie (R \div S) \right)$


AR5. Empleados que trabajan en más de una sucursal.
$\pi_{empleado\_nombre} \left( EMPLEADO \bowtie \sigma_{legajo_1 = legajo_2 \,\wedge\, sucursal_1 \,\neq\, sucursal_2} \left( \text{ASIGNACIÓN\_EMPLEADO} \times \text{ASIGNACIÓN\_EMPLEADO} \right) \right)$ 


AR6. Artículos de equipamiento presentes en TODAS las sucursales. 
Sean:
$R = \pi_{idEquipo, sucursal} \left( EQUIPO \bowtie SALA \bowtie SUCURSAL \right)$
$S = \pi_{sucursal}(SUCURSAL)$
Entonces: 
$\pi_{idEquipo} (R \div S)$


AR7. Socios que asistieron a clases de Yoga Y de Pilates.
$\pi_{socio\_nombre} \left( SOCIO \bowtie \pi_{socio\_dni} \left( \text{INSCRIPCIÓN} \bowtie \sigma_{nombre = 'Yoga'}(CLASE) \right) \right) \cap \pi_{socio\_nombre} \left( SOCIO \bowtie \pi_{socio\_dni} \left( \text{INSCRIPCIÓN} \bowtie \sigma_{nombre = 'Pilates'}(CLASE) \right) \right)$

AR8. Profesores que NO tienen certificaciones vigentes.
$\pi_{empleado\_nombre} \left( \sigma_{cargo = 'Profesor'}(EMPLEADO) \right) - \pi_{empleado\_nombre} \left( EMPLEADO \bowtie \sigma_{fechaVencimiento \,\ge\, fechaActual}(\text{CERTIFICACIÓN}) \right)$

AR9. Facturas del último mes con monto > $30.000.

$\pi_{nro\_factura, fecha} \left( \sigma_{fecha \,\ge\, inicioUltimoMes \,\wedge\, total \,>\, 30000}(FACTURA) \right)$


AR10. Socios que nunca asistieron a una clase grupal.
$\pi_{socio\_nombre}(SOCIO) - \pi_{socio\_nombre} \left( SOCIO \bowtie \text{INSCRIPCIÓN} \bowtie \text{ASISTENCIA} \right)$
