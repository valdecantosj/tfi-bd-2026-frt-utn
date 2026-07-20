/**
 * TP5 - Sistema de Gestión FitChain
 * Parte D.2.b - NoSQL Injection (MongoDB)
 * Comisión 3K03
 *
 * Login vulnerable contra la colección usuarios_app (rol socio_app)
 * en Node.js/Express.
 */

// ============================================================
// CÓDIGO VULNERABLE
// ============================================================
app.post("/login-vulnerable", async (req, res) => {
  const user = await db.collection("usuarios_app").findOne({
    email: req.body.email,
    password: req.body.password, // se usa directo, sin validar tipo
  });
  if (user) res.send("OK");
});

/**
 * ATAQUE
 * En lugar de enviar un string como contraseña, el atacante envía
 * un objeto en el cuerpo JSON de la petición:
 *
 *   { "email": "socio@fitchain.com", "password": { "$gt": "" } }
 *
 * MongoDB interpreta password: {$gt: ""} como el operador "mayor
 * que cadena vacía", condición que cumple prácticamente cualquier
 * contraseña almacenada, permitiendo el acceso sin conocer la
 * clave real. El mismo efecto se logra con {"$ne": null}.
 */


// ============================================================
// CORRECCIÓN
// ============================================================
const bcrypt = require("bcrypt");

app.post("/login", async (req, res) => {
  const { email, password } = req.body;

  // 1) Forzar tipos: rechazar cualquier valor que no sea string
  //    (esto por sí solo bloquea el payload {$gt: ""} del ataque)
  if (typeof email !== "string" || typeof password !== "string") {
    return res.status(400).send("Datos inválidos");
  }

  // 2) Buscar únicamente por email; nunca incluir el password en el filtro
  const user = await db.collection("usuarios_app").findOne({ email });

  // 3) Comparar el hash de forma segura, nunca en texto plano
  if (!user || !(await bcrypt.compare(password, user.passwordHash))) {
    return res.status(401).send("Credenciales inválidas");
  }
  res.send("OK");
});

// Defensa en profundidad adicional (opcional):
// const mongoSanitize = require("express-mongo-sanitize");
// app.use(mongoSanitize()); // elimina del body cualquier clave que empiece con "$"
