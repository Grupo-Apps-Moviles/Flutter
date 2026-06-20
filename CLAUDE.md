# Viacore Backend — Documentación REST API Completa

## Información General

| Campo | Valor |
|---|---|
| **Base URL** | `https://{host}` |
| **Formato** | JSON (`application/json`) |
| **Autenticación** | JWT Bearer Token en header `Authorization: Bearer {token}` |
| **Naming de rutas** | kebab-case, lowercase |
| **Naming en BD** | snake_case |

---

## 1. IAM (Identity & Access Management)

### 1.1 Authentication

#### `POST /api/authentication/sign-up`

Registra un nuevo usuario en el sistema.

**Auth**: No requerida

**Request Body:**
```json
{
  "username": "string",
  "email": "string",
  "password": "string",
  "role": 0
}
```
> `role`: `0` = Traveller (pasajero), `1` = Transport (transportista)

**Response `200 OK`:**
```json
{
  "message": "User created successfully"
}
```

| Código | Caso |
|---|---|
| `200` | Usuario creado exitosamente |
| `400` | Datos inválidos o usuario ya existe |

---

#### `POST /api/authentication/sign-in`

Autentica un usuario y devuelve un JWT.

**Auth**: No requerida

**Request Body:**
```json
{
  "email": "string",
  "password": "string"
}
```

**Response `200 OK`:**
```json
{
  "id": 1,
  "username": "string",
  "role": 0,
  "token": "eyJhbGciOiJIUzI1NiIs..."
}
```

| Código | Caso |
|---|---|
| `200` | Autenticación exitosa |
| `401` | Credenciales inválidas |

---

### 1.2 Users

#### `GET /api/users`

Obtiene todos los usuarios.

**Auth**: Bearer Token

**Response `200 OK`:**
```json
[
  {
    "id": 1,
    "username": "string",
    "role": 0
  }
]
```

---

#### `GET /api/users/{id}`

Obtiene un usuario por su ID.

**Auth**: Bearer Token

**Response `200 OK`:**
```json
{
  "id": 1,
  "username": "string",
  "role": 0
}
```

| Código | Caso |
|---|---|
| `200` | Usuario encontrado |
| `404` | Usuario no encontrado |

---

#### `GET /api/users/email/{email}`

Obtiene un usuario por su email.

**Auth**: Bearer Token

**Response `200 OK`:**
```json
{
  "id": 1,
  "username": "string",
  "role": 0
}
```

| Código | Caso |
|---|---|
| `200` | Usuario encontrado |
| `404` | Email no registrado |

---

## 2. Companies

### 2.1 Companies

#### `POST /api/companies`

Crea una nueva empresa. Acepta `multipart/form-data` con logo opcional.

**Auth**: Bearer Token
**Content-Type**: `multipart/form-data`

**Form fields:**
| Campo | Tipo | Requerido | Descripción |
|---|---|---|---|
| `Name` | `string` | Sí | Nombre de la empresa |
| `FkIdUser` | `int` | Sí | ID del usuario propietario |
| `LogoFile` | `file` | No | Imagen del logo (subida a Cloudinary) |

**Response `201 Created`:**
```json
{
  "id": 1,
  "name": "Transportes Lima",
  "logoUrl": "https://res.cloudinary.com/...",
  "fkIdUser": 1,
  "invitationCode": "ABC123XYZ"
}
```

| Código | Caso |
|---|---|
| `201` | Empresa creada |
| `400` | Datos inválidos o error de creación |

---

#### `GET /api/companies`

Lista todas las empresas.

**Auth**: Bearer Token

**Response `200 OK`:**
```json
[
  {
    "id": 1,
    "name": "string",
    "logoUrl": "string",
    "fkIdUser": 1,
    "invitationCode": "ABC123XYZ"
  }
]
```

---

#### `GET /api/companies/{id}`

Obtiene una empresa por ID.

**Auth**: Bearer Token

**Response `200 OK`:**
```json
{
  "id": 1,
  "name": "string",
  "logoUrl": "string",
  "fkIdUser": 1,
  "invitationCode": "ABC123XYZ"
}
```

| Código | Caso |
|---|---|
| `200` | Empresa encontrada |
| `404` | Empresa no encontrada |

---

#### `GET /api/companies/user/{FKeyIdUser}`

Verifica si un usuario tiene una empresa asociada.

**Auth**: Bearer Token

**Response `200 OK`:** CompanyResource (misma estructura anterior)

| Código | Caso |
|---|---|
| `200` | El usuario tiene empresa |
| `404` | El usuario no tiene empresa |

---

#### `PUT /api/companies/{id}`

Actualiza una empresa existente.

**Auth**: Bearer Token

**Request Body:**
```json
{
  "id": 1,
  "name": "string",
  "logoUrl": "string",
  "fkIdUser": 1
}
```

**Response `200 OK`:** CompanyResource actualizado

| Código | Caso |
|---|---|
| `200` | Empresa actualizada |
| `400` | ID en URL no coincide con body |
| `404` | Empresa no encontrada |

---

#### `DELETE /api/companies/{id}`

Elimina una empresa.

**Auth**: Bearer Token

| Código | Caso |
|---|---|
| `204` | Empresa eliminada |
| `404` | Empresa no encontrada |

---

### 2.2 Memberships

#### `GET /api/memberships/me`

Obtiene la membresía del usuario autenticado (vía JWT).

**Auth**: Bearer Token

**Response `200 OK`:**
```json
{
  "companyId": 1,
  "companyName": "Transportes Lima",
  "logoUrl": "https://...",
  "memberRole": "Admin",
  "invitationCode": "ABC123XYZ"
}
```
> `invitationCode` solo se llena si el usuario es Admin; `null` para Driver.

| Código | Caso |
|---|---|
| `200` | Membresía encontrada |
| `401` | Token inválido |
| `404` | El usuario no pertenece a ninguna empresa |

---

#### `POST /api/memberships/join`

Un conductor se une a una empresa usando un código de invitación.

**Auth**: Bearer Token

**Request Body:**
```json
{
  "invitationCode": "ABC123XYZ"
}
```

**Response `200 OK`:**
```json
{
  "id": 1,
  "companyId": 1,
  "companyName": "Transportes Lima",
  "userId": 5,
  "username": "driver1",
  "memberRole": "Driver",
  "joinedAt": "2026-06-20T10:00:00Z"
}
```

| Código | Caso |
|---|---|
| `200` | Unión exitosa |
| `401` | Token inválido |
| `404` | Código de invitación inválido |
| `409` | El usuario ya pertenece a una empresa |

---

#### `DELETE /api/memberships/me`

El usuario autenticado abandona su empresa (solo Drivers).

**Auth**: Bearer Token

| Código | Caso |
|---|---|
| `204` | Abandono exitoso |
| `401` | Token inválido |
| `404` | No tiene membresía |
| `409` | Un Admin no puede abandonar la empresa |

---

#### `GET /api/memberships/company/{companyId}`

Lista los miembros de una empresa (solo Admin).

**Auth**: Bearer Token

**Response `200 OK`:**
```json
[
  {
    "id": 1,
    "companyId": 1,
    "companyName": "Transportes Lima",
    "userId": 5,
    "username": "driver1",
    "memberRole": "Driver",
    "joinedAt": "2026-06-20T10:00:00Z"
  }
]
```

| Código | Caso |
|---|---|
| `200` | Lista de miembros |
| `401` | Token inválido |
| `403` | Solo el admin puede listar miembros |

---

#### `DELETE /api/memberships/{membershipId}`

Remueve un miembro de la empresa (solo Admin).

**Auth**: Bearer Token

| Código | Caso |
|---|---|
| `204` | Miembro removido |
| `401` | Token inválido |
| `403` | Solo el admin puede remover |
| `404` | Membresía no encontrada |
| `409` | No se puede remover al admin |

---

#### `POST /api/memberships/company/{companyId}/invitation-code/regenerate`

Regenera el código de invitación de la empresa (solo Admin).

**Auth**: Bearer Token

**Response `200 OK`:** CompanyResource con nuevo `invitationCode`

| Código | Caso |
|---|---|
| `200` | Código regenerado |
| `401` | Token inválido |
| `403` | Solo el admin puede regenerar |
| `404` | Empresa no encontrada |

---

## 3. Geographic (Regions, Provinces, Districts)

### 3.1 Seed

#### `POST /api/geographic/seed`

Importa datos geográficos desde API externa. Idempotente.

**Response `200 OK`:**
```json
{
  "seeded": true,
  "regions": 25,
  "provinces": 196,
  "districts": 1874
}
```
o si ya estaban cargados:
```json
{
  "seeded": false,
  "message": "Los datos geográficos ya estaban cargados."
}
```

---

### 3.2 Regions

#### `GET /api/geographic/regions`

Lista todas las regiones.

**Response `200 OK`:**
```json
[
  { "id": 1, "name": "Lima" }
]
```

#### `GET /api/geographic/regions/{id}`

Obtiene una región por ID.

| Código | Caso |
|---|---|
| `200` | Región encontrada |
| `404` | Región no encontrada |

---

### 3.3 Provinces

#### `GET /api/geographic/provinces`

Lista todas las provincias.

**Response `200 OK`:**
```json
[
  { "id": 1, "name": "Lima", "fkIdRegion": 15 }
]
```

#### `GET /api/geographic/provinces/{id}`

Obtiene una provincia por ID.

#### `GET /api/geographic/provinces/region/{regionId}`

Obtiene las provincias de una región.

| Código | Caso |
|---|---|
| `200` | Provincias encontradas |
| `404` | No hay provincias para esa región |

---

### 3.4 Districts

#### `GET /api/geographic/districts`

Lista todos los distritos.

**Response `200 OK`:**
```json
[
  { "id": 1, "name": "Miraflores", "fkIdProvince": 1 }
]
```

#### `GET /api/geographic/districts/{id}`

Obtiene un distrito por ID.

#### `GET /api/geographic/districts/province/{provinceId}`

Obtiene los distritos de una provincia.

| Código | Caso |
|---|---|
| `200` | Distritos encontrados |
| `404` | No hay distritos para esa provincia |

---

## 4. Stops

#### `POST /api/stops`

Crea una nueva parada con imagen opcional.

**Content-Type**: `multipart/form-data`

**Form fields:**
| Campo | Tipo | Requerido | Descripción |
|---|---|---|---|
| `Name` | `string` | Sí | Nombre de la parada |
| `GoogleMapsUrl` | `string` | No | URL Google Maps |
| `ImageFile` | `file` | No | Imagen (subida a Cloudinary) |
| `Phone` | `string` | Sí | Teléfono de contacto |
| `FkIdCompany` | `int` | Sí | ID de la empresa |
| `Address` | `string` | Sí | Dirección |
| `Reference` | `string` | Sí | Referencia |
| `FkIdDistrict` | `int` | Sí | ID del distrito |

**Response `201 Created`:**
```json
{
  "id": 1,
  "name": "Paradero Central",
  "googleMapsUrl": "https://maps.google.com/...",
  "imageUrl": "https://res.cloudinary.com/...",
  "phone": "999888777",
  "fkIdCompany": 1,
  "address": "Av. Principal 123",
  "reference": "Frente al parque",
  "fkIdDistrict": 150101
}
```

| Código | Caso |
|---|---|
| `201` | Parada creada |
| `400` | Datos inválidos |

---

#### `GET /api/stops`

Lista todas las paradas.

| Código | Caso |
|---|---|
| `200` | Lista de paradas |
| `404` | No hay paradas |

---

#### `GET /api/stops/{id}`

Obtiene una parada por ID.

| Código | Caso |
|---|---|
| `200` | Parada encontrada |
| `404` | No encontrada |

---

#### `GET /api/stops/company/{FkIdCompany}`

Obtiene paradas por empresa.

#### `GET /api/stops/District/{FkIdDistrict}`

Obtiene paradas por distrito.

#### `GET /api/stops/district/{FkIdDistrict}/name/{Name}`

Busca parada por distrito y nombre.

#### `GET /api/stops/company/{FkIdCompany}/name/{Name}`

Busca parada por empresa y nombre.

---

#### `PUT /api/stops/{id}`

Actualiza una parada.

**Request Body:**
```json
{
  "id": 1,
  "name": "string",
  "googleMapsUrl": "string",
  "imageUrl": "string",
  "phone": "string",
  "fkIdCompany": 1,
  "address": "string",
  "reference": "string",
  "fkIdDistrict": 150101
}
```

| Código | Caso |
|---|---|
| `200` | Parada actualizada |
| `400` | ID en URL no coincide con body |
| `404` | Parada no encontrada |

---

#### `DELETE /api/stops/{id}`

Elimina una parada.

| Código | Caso |
|---|---|
| `204` | Parada eliminada |
| `404` | Parada no encontrada |

---

## 5. Routes

#### `POST /api/routes`

Crea una nueva ruta con paradas y horarios.

**Request Body:**
```json
{
  "frequency": 15,
  "price": 3.50,
  "duration": 45,
  "stopsIds": [1, 2, 3],
  "schedules": [
    {
      "dayOfWeek": "Monday",
      "startTime": "06:00",
      "endTime": "22:00",
      "enabled": true
    }
  ]
}
```

**Response `200 OK`:** Ruta creada (RouteAggregateResource)

| Código | Caso |
|---|---|
| `200` | Ruta creada |
| `400` | Datos inválidos |

---

#### `GET /api/routes`

Lista todas las rutas.

**Response `200 OK`:**
```json
[
  {
    "id": 1,
    "price": 3.50,
    "frequency": 15,
    "duration": 45,
    "stops": [
      {
        "id": 1,
        "name": "Paradero Central",
        "googleMapsUrl": "string",
        "image_url": "string",
        "address": "Av. Principal 123",
        "fk_company_id": 1,
        "fk_district_id": 150101
      }
    ],
    "schedules": [
      {
        "startTime": "06:00",
        "endTime": "22:00",
        "dayOfWeek": "Monday",
        "enabled": true
      }
    ]
  }
]
```

| Código | Caso |
|---|---|
| `200` | Rutas encontradas |
| `404` | No hay rutas |

---

#### `GET /api/routes/{id}`

Obtiene una ruta por ID.

#### `GET /api/routes/company/{FkIdCompany}`

Obtiene rutas por empresa.

#### `GET /api/routes/district/{FkIdDistrict}`

Obtiene rutas por distrito.

---

#### `PUT /api/routes/{id}`

Actualiza una ruta.

**Request Body:**
```json
{
  "price": 4.00,
  "duration": 50,
  "frequency": 20,
  "stopsIds": [1, 2, 4],
  "schedules": [
    {
      "startTime": "07:00",
      "endTime": "21:00",
      "dayOfWeek": "Monday",
      "enabled": true
    }
  ]
}
```

| Código | Caso |
|---|---|
| `200` | Ruta actualizada |
| `404` | Ruta no encontrada |

---

#### `DELETE /api/routes/{id}`

Elimina una ruta.

| Código | Caso |
|---|---|
| `204` | Ruta eliminada |
| `404` | Ruta no encontrada |

---

## 6. Reservations

#### `POST /api/reservations`

Crea una nueva reserva de pasajero.

**Request Body:**
```json
{
  "userId": 1,
  "routeIds": [1, 2],
  "amount": 7.00,
  "paypalTransactionId": "PAY-XXXXX",
  "driverId": 3
}
```

**Response `201 Created`:**
```json
{
  "id": 1,
  "userId": 1,
  "driverId": 3,
  "status": "Paid",
  "amount": 7.00,
  "driverEarnings": 7.00,
  "platformFee": 0.00,
  "paypalTransactionId": "PAY-XXXXX",
  "createdAt": "2026-06-20T15:30:00Z"
}
```

| Código | Caso |
|---|---|
| `201` | Reserva creada |
| `400` | Error en creación |

---

#### `GET /api/reservations/{reservationId}`

Obtiene una reserva por ID.

| Código | Caso |
|---|---|
| `200` | Reserva encontrada |
| `404` | Reserva no encontrada |

---

#### `GET /api/reservations/user/{userId}`

Lista todas las reservas de un pasajero.

**Response `200 OK`:** Array de ReservationResource

---

#### `GET /api/reservations/driver/{driverId}`

Lista todas las reservas asignadas a un conductor.

**Response `200 OK`:** Array de ReservationResource

---

## 7. Subscriptions

#### `POST /api/v1/subscriptions`

Crea una suscripción PayPal para la empresa del usuario autenticado (solo Admin).

**Auth**: Bearer Token

**Response `200 OK`:**
```json
{
  "approvalUrl": "https://www.paypal.com/webapps/billing/subscriptions?approval_url=..."
}
```

| Código | Caso |
|---|---|
| `200` | URL de aprobación generada |
| `401` | Token inválido |
| `403` | Solo el admin puede gestionar la suscripción |
| `409` | Ya existe suscripción activa o no pertenece a empresa |

---

#### `GET /api/v1/subscriptions/me`

Obtiene el estado de suscripción de la empresa del usuario autenticado.

**Auth**: Bearer Token

**Response `200 OK`:**
```json
{
  "isActive": true,
  "status": "Active",
  "expiresAt": "2027-06-20T00:00:00Z"
}
```

| Código | Caso |
|---|---|
| `200` | Siempre retorna 200 (con `isActive: false` si no tiene) |
| `401` | Token inválido |

---

#### `GET /api/v1/subscriptions/premium-feature`

Verifica si la empresa del usuario tiene suscripción activa (gating).

**Auth**: Bearer Token

| Código | Caso |
|---|---|
| `200` | `{ "message": "Acceso premium concedido." }` |
| `401` | Token inválido |
| `403` | No pertenece a empresa o suscripción inactiva |

---

### PayPal Webhook

#### `POST /api/v1/paypal/webhooks`

Recibe eventos webhook de PayPal. Uso interno.

**Auth**: No requerida (validación vía PayPal)

Eventos manejados:
- `BILLING.SUBSCRIPTION.ACTIVATED` → Activa la suscripción
- `BILLING.SUBSCRIPTION.CANCELLED` / `SUSPENDED` → Cancela
- `BILLING.SUBSCRIPTION.RENEWED` / `PAYMENT.SALE.COMPLETED` → Renueva

**Response**: Siempre `200 OK`

---

## 8. Favorites

#### `POST /api/favorite-routes`

Un pasajero marca una ruta como favorita. Rechaza duplicados.

**Request Body:**
```json
{
  "passengerId": 1,
  "routeId": 5
}
```

**Response `201 Created`:**
```json
{
  "id": 1,
  "passengerId": 1,
  "routeId": 5,
  "createdAt": "2026-06-20T15:30:00Z"
}
```

**Header**: `Location: /api/favorite-routes/1`

| Código | Caso |
|---|---|
| `201` | Favorito creado |
| `400` | Ya existe este favorito o datos inválidos |

---

#### `GET /api/favorite-routes/{favoriteRouteId}`

Obtiene un favorito por su ID.

**Response `200 OK`:**
```json
{
  "id": 1,
  "passengerId": 1,
  "routeId": 5,
  "createdAt": "2026-06-20T15:30:00Z"
}
```

| Código | Caso |
|---|---|
| `200` | Favorito encontrado |
| `404` | No existe |

---

#### `GET /api/favorite-routes/passenger/{passengerId}`

Lista todas las rutas favoritas de un pasajero.

**Response `200 OK`:**
```json
[
  {
    "id": 1,
    "passengerId": 1,
    "routeId": 5,
    "createdAt": "2026-06-20T15:30:00Z"
  },
  {
    "id": 3,
    "passengerId": 1,
    "routeId": 12,
    "createdAt": "2026-06-20T16:45:00Z"
  }
]
```

| Código | Caso |
|---|---|
| `200` | Siempre 200, `[]` si no tiene favoritos |

---

#### `DELETE /api/favorite-routes/{favoriteRouteId}`

Elimina una ruta de favoritos.

| Código | Caso |
|---|---|
| `204` | Favorito eliminado |
| `404` | Favorito no encontrado |

---

## Resumen de todos los endpoints

| # | Método | Ruta | BC | Descripción |
|---|---|---|---|---|
| 1 | `POST` | `/api/authentication/sign-up` | IAM | Registro de usuario |
| 2 | `POST` | `/api/authentication/sign-in` | IAM | Login (retorna JWT) |
| 3 | `GET` | `/api/users` | IAM | Listar usuarios |
| 4 | `GET` | `/api/users/{id}` | IAM | Obtener usuario por ID |
| 5 | `GET` | `/api/users/email/{email}` | IAM | Obtener usuario por email |
| 6 | `POST` | `/api/companies` | Companies | Crear empresa (multipart) |
| 7 | `GET` | `/api/companies` | Companies | Listar empresas |
| 8 | `GET` | `/api/companies/{id}` | Companies | Obtener empresa por ID |
| 9 | `GET` | `/api/companies/user/{FKeyIdUser}` | Companies | Verificar empresa por usuario |
| 10 | `PUT` | `/api/companies/{id}` | Companies | Actualizar empresa |
| 11 | `DELETE` | `/api/companies/{id}` | Companies | Eliminar empresa |
| 12 | `GET` | `/api/memberships/me` | Companies | Mi membresía |
| 13 | `POST` | `/api/memberships/join` | Companies | Unirse con código |
| 14 | `DELETE` | `/api/memberships/me` | Companies | Abandonar empresa |
| 15 | `GET` | `/api/memberships/company/{companyId}` | Companies | Listar miembros |
| 16 | `DELETE` | `/api/memberships/{membershipId}` | Companies | Remover miembro |
| 17 | `POST` | `/api/memberships/company/{companyId}/invitation-code/regenerate` | Companies | Regenerar código |
| 18 | `POST` | `/api/geographic/seed` | Geographic | Importar datos geográficos |
| 19 | `GET` | `/api/geographic/regions` | Geographic | Listar regiones |
| 20 | `GET` | `/api/geographic/regions/{id}` | Geographic | Obtener región |
| 21 | `GET` | `/api/geographic/provinces` | Geographic | Listar provincias |
| 22 | `GET` | `/api/geographic/provinces/{id}` | Geographic | Obtener provincia |
| 23 | `GET` | `/api/geographic/provinces/region/{regionId}` | Geographic | Provincias por región |
| 24 | `GET` | `/api/geographic/districts` | Geographic | Listar distritos |
| 25 | `GET` | `/api/geographic/districts/{id}` | Geographic | Obtener distrito |
| 26 | `GET` | `/api/geographic/districts/province/{provinceId}` | Geographic | Distritos por provincia |
| 27 | `POST` | `/api/stops` | Stops | Crear parada (multipart) |
| 28 | `GET` | `/api/stops` | Stops | Listar paradas |
| 29 | `GET` | `/api/stops/{id}` | Stops | Obtener parada |
| 30 | `GET` | `/api/stops/company/{FkIdCompany}` | Stops | Paradas por empresa |
| 31 | `GET` | `/api/stops/District/{FkIdDistrict}` | Stops | Paradas por distrito |
| 32 | `GET` | `/api/stops/district/{FkIdDistrict}/name/{Name}` | Stops | Parada por distrito y nombre |
| 33 | `GET` | `/api/stops/company/{FkIdCompany}/name/{Name}` | Stops | Parada por empresa y nombre |
| 34 | `PUT` | `/api/stops/{id}` | Stops | Actualizar parada |
| 35 | `DELETE` | `/api/stops/{id}` | Stops | Eliminar parada |
| 36 | `POST` | `/api/routes` | Routes | Crear ruta |
| 37 | `GET` | `/api/routes` | Routes | Listar rutas |
| 38 | `GET` | `/api/routes/{id}` | Routes | Obtener ruta |
| 39 | `GET` | `/api/routes/company/{FkIdCompany}` | Routes | Rutas por empresa |
| 40 | `GET` | `/api/routes/district/{FkIdDistrict}` | Routes | Rutas por distrito |
| 41 | `PUT` | `/api/routes/{id}` | Routes | Actualizar ruta |
| 42 | `DELETE` | `/api/routes/{id}` | Routes | Eliminar ruta |
| 43 | `POST` | `/api/reservations` | Reservations | Crear reserva |
| 44 | `GET` | `/api/reservations/{reservationId}` | Reservations | Obtener reserva |
| 45 | `GET` | `/api/reservations/user/{userId}` | Reservations | Reservas por pasajero |
| 46 | `GET` | `/api/reservations/driver/{driverId}` | Reservations | Reservas por conductor |
| 47 | `POST` | `/api/v1/subscriptions` | Subscriptions | Crear suscripción |
| 48 | `GET` | `/api/v1/subscriptions/me` | Subscriptions | Mi suscripción |
| 49 | `GET` | `/api/v1/subscriptions/premium-feature` | Subscriptions | Verificar premium |
| 50 | `POST` | `/api/v1/paypal/webhooks` | Subscriptions | Webhook PayPal |
| 51 | `POST` | `/api/favorite-routes` | Favorites | Crear favorito |
| 52 | `GET` | `/api/favorite-routes/{favoriteRouteId}` | Favorites | Obtener favorito |
| 53 | `GET` | `/api/favorite-routes/passenger/{passengerId}` | Favorites | Favoritos por pasajero |
| 54 | `DELETE` | `/api/favorite-routes/{favoriteRouteId}` | Favorites | Eliminar favorito |