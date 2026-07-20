/**
 * TP5 - Sistema de Gestión FitChain
 * Parte C.1 - Diseño de Colecciones (JSON Schema)
 * Parte C.2 - Operaciones CRUD (primera mitad)
 * Comisión 3K03
 *
 * Colecciones a cargo:
 *   - training_routines
 *   - progress_logs
 *   - body_measurements
 *
 * Ejecutar en mongosh conectado a la base "fitchain" (MongoDB Atlas, tier M0).
 */

use("fitchain");

// ============================================================
// C.1 - DISEÑO DE COLECCIONES
// ============================================================

// ------------------------------------------------------------
// 1) training_routines
// ------------------------------------------------------------
// Justificación (MongoDB vs. PostgreSQL):
// Cada rutina tiene una cantidad variable de ejercicios, cada uno con sus
// propios atributos (series, repeticiones, peso, descanso). En PostgreSQL
// esto exigiría tablas adicionales (RUTINA_EJERCICIO, EJERCICIO) con
// múltiples JOIN solo para reconstruir una rutina completa. En MongoDB la
// rutina y sus ejercicios anidados viven en un único documento, lo que es
// natural para el caso de uso principal (leer/escribir la rutina completa
// de un socio en una sola operación).
db.training_routines.drop();
db.createCollection("training_routines", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["idSocio", "nombre", "fechaCreacion", "ejercicios", "activa"],
      properties: {
        idSocio: {
          bsonType: "int",
          description: "FK lógica a SOCIO(idSocio) en PostgreSQL - obligatorio"
        },
        nombre: {
          bsonType: "string",
          minLength: 3,
          description: "Nombre de la rutina - obligatorio"
        },
        objetivo: {
          bsonType: "string",
          description: "Objetivo de la rutina (ej: Hipertrofia, Descenso de peso)"
        },
        fechaCreacion: {
          bsonType: "date",
          description: "Fecha de creación - obligatorio"
        },
        creadoPor: {
          bsonType: "object",
          properties: {
            idEmpleado: { bsonType: "int" },
            nombre: { bsonType: "string" }
          },
          description: "Profesor/personal trainer que creó la rutina"
        },
        activa: {
          bsonType: "bool",
          description: "Indica si la rutina está vigente - obligatorio"
        },
        ejercicios: {
          bsonType: "array",
          minItems: 1,
          description: "Lista de ejercicios - obligatorio, al menos 1",
          items: {
            bsonType: "object",
            required: ["nombre", "series", "repeticiones"],
            properties: {
              nombre: { bsonType: "string" },
              grupoMuscular: { bsonType: "string" },
              series: { bsonType: "int", minimum: 1 },
              repeticiones: { bsonType: "int", minimum: 1 },
              pesoKg: { bsonType: ["double", "int"], minimum: 0 },
              descansoSegundos: { bsonType: "int", minimum: 0 },
              notas: { bsonType: "string" }
            }
          }
        }
      }
    }
  },
  validationLevel: "strict",
  validationAction: "error"
});
/* Resultado obtenido: { ok: 1 } */


// ------------------------------------------------------------
// 2) progress_logs
// ------------------------------------------------------------
// Justificación (MongoDB vs. PostgreSQL):
// No todos los socios registran las mismas mediciones (algunos solo peso,
// otros peso + % grasa + medidas, otros además marcas personales). En un
// modelo relacional esto implicaría muchas columnas opcionales (NULL en la
// mayoría de los casos) o una tabla EAV incómoda de consultar. En MongoDB
// cada documento incluye solo los campos que el socio efectivamente
// registró. Complementa (no reemplaza) a la tabla PROGRESO_FISICO de
// PostgreSQL: esta última guarda el registro oficial/estructurado, mientras
// que progress_logs habilita el registro flexible.
db.createCollection("progress_logs", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["idSocio", "fecha", "mediciones"],
      properties: {
        idSocio: {
          bsonType: "int",
          description: "FK lógica a SOCIO(idSocio) en PostgreSQL - obligatorio"
        },
        fecha: {
          bsonType: "date",
          description: "Fecha del registro - obligatorio"
        },
        mediciones: {
          bsonType: "object",
          description: "Mediciones variables según lo que registró el socio",
          properties: {
            pesoKg: { bsonType: ["double", "int"], minimum: 0 },
            porcentajeGrasa: {
              bsonType: ["double", "int"], minimum: 0, maximum: 100
            },
            medidasCm: {
              bsonType: "object",
              properties: {
                biceps: { bsonType: ["double", "int"] },
                pecho: { bsonType: ["double", "int"] },
                cintura: { bsonType: ["double", "int"] },
                cadera: { bsonType: ["double", "int"] },
                muslo: { bsonType: ["double", "int"] }
              }
            }
          },
          minProperties: 1
        },
        marcasPersonales: {
          bsonType: "array",
          description: "Records/PRs alcanzados en la fecha",
          items: {
            bsonType: "object",
            required: ["ejercicio", "valor"],
            properties: {
              ejercicio: { bsonType: "string" },
              valor: { bsonType: "string" }
            }
          }
        },
        registradoPor: {
          bsonType: "object",
          properties: {
            idEmpleado: { bsonType: "int" },
            nombre: { bsonType: "string" }
          },
          description: "Personal trainer que tomó la medición (si aplica)"
        }
      }
    }
  },
  validationLevel: "strict",
  validationAction: "error"
});
/* Resultado obtenido: { ok: 1 } */


// ------------------------------------------------------------
// 3) body_measurements
// ------------------------------------------------------------
// Justificación (MongoDB vs. PostgreSQL):
// Serie temporal de mediciones tomadas por dispositivos (básculas
// inteligentes / IoT): alta frecuencia de inserción, prácticamente nunca se
// actualiza (historial inmutable) y se consulta mayormente por rangos de
// fecha para graficar tendencias. Se evaluó el modo "timeseries" nativo de
// MongoDB (timeField/metaField); por limitaciones de compatibilidad en el
// entorno usado (Atlas M0), se optó por la alternativa funcionalmente
// equivalente: colección estándar con validador + índice compuesto
// (idSocio, timestamp), que garantiza el mismo patrón de consulta eficiente.
db.createCollection("body_measurements", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["idSocio", "timestamp", "pesoKg"],
      properties: {
        idSocio: { bsonType: "int" },
        timestamp: { bsonType: "date" },
        dispositivo: { bsonType: "string" },
        pesoKg: { bsonType: ["double", "int"], minimum: 0 },
        porcentajeGrasa: {
          bsonType: ["double", "int"], minimum: 0, maximum: 100
        },
        porcentajeMusculo: {
          bsonType: ["double", "int"], minimum: 0, maximum: 100
        },
        imc: { bsonType: ["double", "int"], minimum: 0 },
        aguaCorporalPorcentaje: {
          bsonType: ["double", "int"], minimum: 0, maximum: 100
        }
      }
    }
  },
  validationLevel: "strict",
  validationAction: "error"
});
db.body_measurements.createIndex({ "idSocio": 1, "timestamp": -1 });
/* Resultado obtenido:
   { ok: 1 }
   idSocio_1_timestamp_-1
*/

// Verificación de las 3 colecciones creadas:
show collections;
/* Resultado obtenido:
   body_measurements
   progress_logs
   training_routines
*/


// ============================================================
// C.2 - OPERACIONES CRUD (primera mitad)
// ============================================================

// ------------------------------------------------------------
// training_routines
// ------------------------------------------------------------

// 1) INSERT - insertOne
db.training_routines.insertOne({
  idSocio: 1,
  nombre: "Rutina Hipertrofia - Fase 1",
  objetivo: "Aumentar masa muscular",
  fechaCreacion: new Date("2026-05-01"),
  creadoPor: { idEmpleado: 9, nombre: "Tomás Acosta" },
  activa: true,
  ejercicios: [
    { nombre: "Press de banca", grupoMuscular: "Pecho", series: 4,
      repeticiones: 10, pesoKg: 60, descansoSegundos: 90,
      notas: "Controlar la bajada" },
    { nombre: "Sentadilla", grupoMuscular: "Piernas", series: 4,
      repeticiones: 8, pesoKg: 80, descansoSegundos: 120, notas: "" },
    { nombre: "Remo con barra", grupoMuscular: "Espalda", series: 3,
      repeticiones: 12, pesoKg: 40, descansoSegundos: 60, notas: "" }
  ]
});
/* Resultado obtenido:
{ acknowledged: true, insertedId: ObjectId('6a5a9cd3166c602fe9a736a4') }
*/

// 2) INSERT - insertMany
db.training_routines.insertMany([
  {
    idSocio: 2,
    nombre: "Rutina Descenso de Peso",
    objetivo: "Reducir porcentaje graso",
    fechaCreacion: new Date("2026-05-03"),
    creadoPor: { idEmpleado: 10, nombre: "Julieta Herrera" },
    activa: true,
    ejercicios: [
      { nombre: "Cinta - trote", grupoMuscular: "Cardio", series: 1,
        repeticiones: 1, pesoKg: 0, descansoSegundos: 0,
        notas: "30 minutos ritmo moderado" },
      { nombre: "Burpees", grupoMuscular: "Full body", series: 3,
        repeticiones: 15, pesoKg: 0, descansoSegundos: 45, notas: "" }
    ]
  },
  {
    idSocio: 3,
    nombre: "Rutina Resistencia",
    objetivo: "Mejorar resistencia cardiovascular",
    fechaCreacion: new Date("2026-05-05"),
    creadoPor: { idEmpleado: 9, nombre: "Tomás Acosta" },
    activa: true,
    ejercicios: [
      { nombre: "Bicicleta fija", grupoMuscular: "Cardio", series: 1,
        repeticiones: 1, pesoKg: 0, descansoSegundos: 0, notas: "20 minutos" },
      { nombre: "Sentadilla con salto", grupoMuscular: "Piernas", series: 3,
        repeticiones: 20, pesoKg: 0, descansoSegundos: 30, notas: "" }
    ]
  },
  {
    idSocio: 4,
    nombre: "Rutina Preparación Física",
    objetivo: "Mejorar rendimiento deportivo",
    fechaCreacion: new Date("2026-05-08"),
    creadoPor: { idEmpleado: 4, nombre: "Martina Pérez" },
    activa: false,
    ejercicios: [
      { nombre: "Peso muerto", grupoMuscular: "Espalda", series: 4,
        repeticiones: 6, pesoKg: 70, descansoSegundos: 120,
        notas: "Técnica primero" }
    ]
  }
]);
/* Resultado obtenido:
{
  acknowledged: true,
  insertedIds: {
    '0': ObjectId('6a5a9ceb166c602fe9a736a5'),
    '1': ObjectId('6a5a9ceb166c602fe9a736a6'),
    '2': ObjectId('6a5a9ceb166c602fe9a736a7')
  }
}
*/

// 3) FIND - filtro compuesto con $and + $gte
// Rutinas activas creadas a partir del 1 de mayo de 2026.
db.training_routines.find({
  $and: [
    { activa: true },
    { fechaCreacion: { $gte: new Date("2026-05-01") } }
  ]
});
/* Resultado obtenido: 3 documentos (socios 1, 2 y 3;
   el socio 4 queda excluido por tener activa: false) */

// 4) FIND - filtro compuesto con $or + $regex
// Rutinas con objetivo "Aumentar masa muscular" o cuyo nombre
// contenga "Resistencia" (sin distinguir mayúsculas/minúsculas).
db.training_routines.find({
  $or: [
    { objetivo: "Aumentar masa muscular" },
    { nombre: { $regex: "resistencia", $options: "i" } }
  ]
});
/* Resultado obtenido: 2 documentos (socio 1 y socio 3) */

// 5) UPDATE - $push + $set
// Se agrega un ejercicio a la rutina del socio 1 y se actualiza su objetivo.
db.training_routines.updateOne(
  { idSocio: 1 },
  {
    $push: {
      ejercicios: {
        nombre: "Curl de bíceps",
        grupoMuscular: "Brazos",
        series: 3,
        repeticiones: 12,
        pesoKg: 12,
        descansoSegundos: 45,
        notas: "Agregado en revisión mensual"
      }
    },
    $set: { objetivo: "Aumentar masa muscular - Fase avanzada" }
  }
);
/* Resultado obtenido:
{ acknowledged: true, insertedId: null, matchedCount: 1, modifiedCount: 1, upsertedCount: 0 }
*/

// 6) DELETE - filtro condicional
// Se eliminan las rutinas inactivas.
db.training_routines.deleteMany({ activa: false });
/* Resultado obtenido: { acknowledged: true, deletedCount: 1 } */


// ------------------------------------------------------------
// progress_logs
// ------------------------------------------------------------

// 1) INSERT - insertOne
db.progress_logs.insertOne({
  idSocio: 5,
  fecha: new Date("2026-06-01"),
  mediciones: {
    pesoKg: 78.5,
    porcentajeGrasa: 18.2,
    medidasCm: { biceps: 34, pecho: 98, cintura: 82 }
  },
  marcasPersonales: [
    { ejercicio: "Press de banca", valor: "85 kg" }
  ],
  registradoPor: { idEmpleado: 9, nombre: "Tomás Acosta" }
});
/* Resultado obtenido:
{ acknowledged: true, insertedId: ObjectId('6a5a9e62166c602fe9a736a8') }
*/

// 2) INSERT - insertMany
db.progress_logs.insertMany([
  {
    idSocio: 6,
    fecha: new Date("2026-06-02"),
    mediciones: { pesoKg: 65.0, porcentajeGrasa: 22.5 }
  },
  {
    idSocio: 7,
    fecha: new Date("2026-06-03"),
    mediciones: { pesoKg: 90.2, medidasCm: { cintura: 95, cadera: 102 } },
    marcasPersonales: [
      { ejercicio: "Sentadilla", valor: "120 kg" },
      { ejercicio: "Peso muerto", valor: "140 kg" }
    ]
  },
  {
    idSocio: 5,
    fecha: new Date("2026-07-01"),
    mediciones: {
      pesoKg: 77.0,
      porcentajeGrasa: 17.0,
      medidasCm: { biceps: 34.5, pecho: 99, cintura: 80 }
    },
    registradoPor: { idEmpleado: 9, nombre: "Tomás Acosta" }
  }
]);
/* Resultado obtenido:
{
  acknowledged: true,
  insertedIds: {
    '0': ObjectId('6a5a9e83166c602fe9a736a9'),
    '1': ObjectId('6a5a9e83166c602fe9a736aa'),
    '2': ObjectId('6a5a9e83166c602fe9a736ab')
  }
}
*/

// 3) FIND - filtro compuesto con $and + $gte
// Registros con peso >= 70 kg y fecha >= 1 de junio de 2026.
db.progress_logs.find({
  $and: [
    { "mediciones.pesoKg": { $gte: 70 } },
    { fecha: { $gte: new Date("2026-06-01") } }
  ]
});
/* Resultado obtenido: 3 documentos (socio 5, socio 7 y socio 5;
   el socio 6 queda excluido por tener peso 65 kg) */

// 4) FIND - filtro compuesto con $or
// Registros con % de grasa < 20, o con al menos una marca personal.
db.progress_logs.find({
  $or: [
    { "mediciones.porcentajeGrasa": { $lt: 20 } },
    { marcasPersonales: { $exists: true, $not: { $size: 0 } } }
  ]
});
/* Resultado obtenido: los mismos 3 documentos que la consulta anterior
   (coincidencia del set de prueba); el registro del socio 6 no cumple
   ninguna de las dos condiciones. */

// 5) UPDATE - $set + $push
db.progress_logs.updateOne(
  { idSocio: 6 },
  {
    $set: { "mediciones.pesoKg": 64.5 },
    $push: { marcasPersonales: { ejercicio: "Plancha", valor: "90 segundos" } }
  }
);
/* Resultado obtenido:
{ acknowledged: true, insertedId: null, matchedCount: 1, modifiedCount: 1, upsertedCount: 0 }
*/

// 6) DELETE - filtro condicional
// Limpieza de registros con más de 6 meses de antigüedad.
db.progress_logs.deleteMany({ fecha: { $lt: new Date("2026-01-01") } });
/* Resultado obtenido: { acknowledged: true, deletedCount: 0 }
   (no elimina nada con el set de prueba actual, todo es de 2026;
   se documenta igual el comando y su resultado real) */


// ------------------------------------------------------------
// body_measurements
// ------------------------------------------------------------

// 1) INSERT - insertOne
db.body_measurements.insertOne({
  idSocio: 8,
  timestamp: new Date("2026-06-15T07:30:00Z"),
  dispositivo: "bascula-smart-01",
  pesoKg: 82.3,
  porcentajeGrasa: 20.1,
  porcentajeMusculo: 42.5,
  imc: 25.4,
  aguaCorporalPorcentaje: 55.2
});
/* Resultado obtenido:
{ acknowledged: true, insertedId: ObjectId('6a5a9f90166c602fe9a736ac') }
*/

// 2) INSERT - insertMany
db.body_measurements.insertMany([
  {
    idSocio: 9,
    timestamp: new Date("2026-06-16T08:00:00Z"),
    dispositivo: "bascula-smart-01",
    pesoKg: 70.0,
    porcentajeGrasa: 15.0,
    imc: 22.1
  },
  {
    idSocio: 8,
    timestamp: new Date("2026-07-01T07:15:00Z"),
    dispositivo: "bascula-smart-01",
    pesoKg: 81.0,
    porcentajeGrasa: 19.4,
    porcentajeMusculo: 43.0,
    imc: 25.0,
    aguaCorporalPorcentaje: 56.0
  },
  {
    idSocio: 10,
    timestamp: new Date("2026-07-02T09:00:00Z"),
    dispositivo: "app-manual",
    pesoKg: 60.5,
    imc: 21.3
  }
]);
/* Resultado obtenido:
{
  acknowledged: true,
  insertedIds: {
    '0': ObjectId('6a5a9fa5166c602fe9a736ad'),
    '1': ObjectId('6a5a9fa5166c602fe9a736ae'),
    '2': ObjectId('6a5a9fa5166c602fe9a736af')
  }
}
*/

// 3) FIND - filtro compuesto con $and + $gte
// Mediciones con peso >= 75 kg a partir de junio de 2026.
db.body_measurements.find({
  $and: [
    { pesoKg: { $gte: 75 } },
    { timestamp: { $gte: new Date("2026-06-01T00:00:00Z") } }
  ]
});
/* Resultado obtenido: 2 documentos (los dos controles del socio 8) */

// 4) FIND - filtro compuesto con $or + $regex
// Mediciones por báscula inteligente, o con % de grasa < 18.
db.body_measurements.find({
  $or: [
    { dispositivo: { $regex: "^bascula", $options: "i" } },
    { porcentajeGrasa: { $lt: 18 } }
  ]
});
/* Resultado obtenido: 3 documentos (socio 8 x2, socio 9);
   el registro por app-manual del socio 10 queda excluido */

// 5) UPDATE - $set + $inc
db.body_measurements.updateOne(
  { idSocio: 9, dispositivo: "bascula-smart-01" },
  {
    $set: { imc: 22.3 },
    $inc: { pesoKg: 0.1 }
  }
);
/* Resultado obtenido:
{ acknowledged: true, insertedId: null, matchedCount: 1, modifiedCount: 1, upsertedCount: 0 }
*/

// 6) DELETE - filtro condicional
// Se eliminan las mediciones manuales (no provenientes de sensor IoT).
db.body_measurements.deleteMany({ dispositivo: "app-manual" });
/* Resultado obtenido: { acknowledged: true, deletedCount: 1 } */
