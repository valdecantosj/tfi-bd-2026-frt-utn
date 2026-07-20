/**
 * TP5 - Sistema de Gestión FitChain
 * Parte C.3 - Aggregation Pipeline (MongoDB)
 * Comisión 3K03
 *
 * Ejecutar en mongosh conectado a la base "fitchain".
 * Requiere las colecciones: training_routines, access_logs,
 * body_measurements, equipment_iot, class_feedback, profesores_ref
 */

use("fitchain");

// ===========================================================
// AGG1: Promedio de duración de rutinas por tipo de entrenamiento
// ($group, $avg)
// ===========================================================
// La colección training_routines no tiene un campo de duración total
// explícito, por lo que se calcula dentro del propio pipeline a partir
// de los ejercicios anidados (series x descanso + tiempo estimado de
// ejecución). Se usa el campo "objetivo" como tipo de entrenamiento.
db.training_routines.aggregate([
  { $project: {
      objetivo: 1,
      duracionMin: {
        $divide: [
          { $sum: { $map: { input: "$ejercicios", as: "e",
            in: { $multiply: ["$$e.series", { $add: ["$$e.descansoSegundos", 20] }] } } } },
          60
        ]
      }
  }},
  { $group: { _id: "$objetivo", duracionPromedioMin: { $avg: "$duracionMin" }, cantidadRutinas: { $sum: 1 } } },
  { $sort: { duracionPromedioMin: -1 } }
]);

/* Resultado obtenido:
[
  { _id: 'Hipertrofia', duracionPromedioMin: 11, cantidadRutinas: 2 },
  { _id: 'Funcional', duracionPromedioMin: 3.25, cantidadRutinas: 1 }
]
*/


// ===========================================================
// AGG2: Top 10 socios con más check-ins por mes
// ($group, $sort, $limit)
// ===========================================================
db.access_logs.aggregate([
  { $match: { tipoEvento: "check-in", timestamp: { $gte: new Date("2026-07-01"), $lt: new Date("2026-08-01") } } },
  { $group: { _id: "$idSocio", totalCheckins: { $sum: 1 } } },
  { $sort: { totalCheckins: -1 } },
  { $limit: 10 }
]);

/* Resultado obtenido:
[ { _id: 2, totalCheckins: 3 }, { _id: 11, totalCheckins: 1 } ]
*/


// ===========================================================
// AGG3: Evolución del peso promedio de socios por mes
// ($group por fecha, $avg)
// ===========================================================
db.body_measurements.aggregate([
  { $group: {
      _id: { anio: { $year: "$timestamp" }, mes: { $month: "$timestamp" } },
      pesoPromedio: { $avg: "$pesoKg" },
      cantidadMediciones: { $sum: 1 }
  }},
  { $sort: { "_id.anio": 1, "_id.mes": 1 } }
]);

/* Resultado obtenido:
[
  { _id: { anio: 2026, mes: 6 }, pesoPromedio: 76.15, cantidadMediciones: 2 },
  { _id: { anio: 2026, mes: 7 }, pesoPromedio: 80.23333333333333, cantidadMediciones: 3 }
]
*/


// ===========================================================
// AGG4: Equipos que necesitan mantenimiento
// basado en horas de uso y vibraciones ($match, $project)
// ===========================================================
db.equipment_iot.aggregate([
  { $match: { $or: [
      { horasUsoAcumuladas: { $gte: 1000 } },
      { "lecturas.vibracionMmS": { $gte: 4 } }
  ]}},
  { $project: {
      idEquipo: 1, tipoEquipo: 1, horasUsoAcumuladas: 1,
      vibracion: "$lecturas.vibracionMmS",
      alerta: { $cond: [{ $gte: ["$lecturas.vibracionMmS", 4] }, "Vibración crítica", "Mantenimiento por horas de uso"] }
  }}
]);

/* Resultado obtenido:
[
  { idEquipo: 45, tipoEquipo: 'cinta', horasUsoAcumuladas: 1230.5, vibracion: 1.2,
    alerta: 'Mantenimiento por horas de uso' },
  { idEquipo: 45, tipoEquipo: 'cinta', horasUsoAcumuladas: 1231, vibracion: 4.8,
    alerta: 'Vibración crítica' }
]
*/


// ===========================================================
// AGG5: Rating promedio por clase y por profesor
// ($unwind, $group, $lookup)
// ===========================================================
// Nota de diseño: MongoDB no puede hacer JOIN directo contra PostgreSQL
// (donde reside la tabla EMPLEADO), por lo que se mantiene una colección
// liviana de referencia "profesores_ref", sincronizada desde PostgreSQL,
// que permite aplicar $lookup dentro del mismo motor.
db.class_feedback.aggregate([
  { $group: { _id: { idClase: "$idClase", idProfesor: "$idProfesor" },
      ratingPromedio: { $avg: "$ratings.general" }, respuestas: { $sum: 1 } } },
  { $lookup: { from: "profesores_ref", localField: "_id.idProfesor", foreignField: "_id", as: "profesor" } },
  { $unwind: "$profesor" },
  { $project: { _id: 0, idClase: "$_id.idClase",
      profesor: { $concat: ["$profesor.nombre", " ", "$profesor.apellido"] },
      ratingPromedio: { $round: ["$ratingPromedio", 2] }, respuestas: 1 } },
  { $sort: { ratingPromedio: -1 } }
]);

/* Resultado obtenido:
[
  { respuestas: 2, idClase: 1, profesor: 'Agustín Romero', ratingPromedio: 4.5 },
  { respuestas: 1, idClase: 2, profesor: 'Camila Morales', ratingPromedio: 4 }
]
*/
