use fitchain_db

db.createRole({
  role: "admin_sistema",
  privileges: [
    { resource: { db: "fitchain_db", collection: "" }, actions: ["find", "insert", "update", "remove"] }
  ],
  roles: []
});

db.createRole({
  role: "gerente_sucursal",
  privileges: [
    { resource: { db: "fitchain_db", collection: "empleado" }, actions: ["find", "insert", "update", "remove"] },
    { resource: { db: "fitchain_db", collection: "sucursal" }, actions: ["find", "insert", "update", "remove"] },
    { resource: { db: "fitchain_db", collection: "factura" }, actions: ["find", "insert", "update", "remove"] }
  ],
  roles: []
});

db.createRole({
  role: "recepcionista",
  privileges: [
    { resource: { db: "fitchain_db", collection: "socio" }, actions: ["find", "insert", "update"] },
    { resource: { db: "fitchain_db", collection: "membresia" }, actions: ["find", "insert", "update"] },
    { resource: { db: "fitchain_db", collection: "pago" }, actions: ["find", "insert", "update"] }
  ],
  roles: []
});

db.createRole({
  role: "profesor",
  privileges: [
    { resource: { db: "fitchain_db", collection: "socio" }, actions: ["find"] },
    { resource: { db: "fitchain_db", collection: "clase" }, actions: ["find"] }
  ],
  roles: []
});

db.createRole({
  role: "socio_app",
  privileges: [
    { resource: { db: "fitchain_db", collection: "clase" }, actions: ["find"] }
  ],
  roles: []
});