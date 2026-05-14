# Feature Spec: Goals

## Status
- [ ] Spec aprobada
- [ ] Capa domain completa
- [ ] Capa data completa
- [ ] Capa presentation completa
- [ ] Tests escritos
- [ ] Feature revisado

## Overview
Módulo principal que permite al usuario crear metas financieras con un monto objetivo y fecha límite, registrar abonos de progreso y consultar el estado de cada meta en tiempo real. El usuario puede actualizar cualquier aspecto de una meta activa y marcarla como completada o cancelada cuando corresponda.

## User Stories
- Como usuario, quiero crear una meta con nombre, monto objetivo y fecha límite.
- Como usuario, quiero ver la lista de mis metas con su progreso actual.
- Como usuario, quiero registrar un abono a una meta para actualizar su progreso.
- Como usuario, quiero editar el nombre, descripción o fecha de una meta activa.
- Como usuario, quiero marcar una meta como completada o cancelada.
- Como usuario, quiero eliminar una meta que ya no me interesa.

## Domain Entities

- **Goal**
  - `id`: String — identificador único
  - `title`: String — nombre de la meta
  - `description`: String? — descripción opcional
  - `targetAmount`: double — monto objetivo
  - `currentAmount`: double — monto acumulado hasta ahora
  - `deadline`: DateTime — fecha límite
  - `status`: GoalStatus — estado actual
  - `createdAt`: DateTime
  - `updatedAt`: DateTime

- **GoalStatus** (enum): `active`, `completed`, `cancelled`

- **Regla de negocio:** `currentAmount` nunca puede superar `targetAmount`. Al alcanzarlo, el status pasa automáticamente a `completed`.

## Use Cases

- **CreateGoal(params: CreateGoalParams): (Goal?, Failure?)**
  - Input: title, targetAmount, deadline, description?
  - Valida: targetAmount > 0, deadline > now

- **GetGoals(): (List\<Goal\>?, Failure?)**
  - Retorna todas las metas del usuario ordenadas por deadline ascendente

- **GetGoalById(id: String): (Goal?, Failure?)**
  - Retorna la meta o `ServerFailure` si no existe

- **UpdateGoal(params: UpdateGoalParams): (Goal?, Failure?)**
  - Input: id + campos opcionales (title, description, deadline)
  - Solo permitido si status == active

- **AddProgress(goalId: String, amount: double): (Goal?, Failure?)**
  - Incrementa `currentAmount` en `amount`
  - Valida: amount > 0, status == active
  - Si currentAmount >= targetAmount → cambia status a completed automáticamente

- **DeleteGoal(id: String): (bool?, Failure?)**
  - Elimina la meta localmente y en el servidor

## Repository Interface

```dart
abstract interface class GoalsRepository {
  Future<(Goal?, Failure?)> createGoal(CreateGoalParams params);
  Future<(List<Goal>?, Failure?)> getGoals();
  Future<(Goal?, Failure?)> getGoalById(String id);
  Future<(Goal?, Failure?)> updateGoal(UpdateGoalParams params);
  Future<(Goal?, Failure?)> addProgress(String goalId, double amount);
  Future<(bool?, Failure?)> deleteGoal(String id);
}
```

## API Contract

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| POST | `/goals` | Crear meta |
| GET | `/goals` | Listar metas del usuario |
| GET | `/goals/:id` | Detalle de meta |
| PUT | `/goals/:id` | Actualizar meta |
| POST | `/goals/:id/progress` | Registrar abono |
| DELETE | `/goals/:id` | Eliminar meta |

**Request body — POST /goals:**
```json
{ "title": "string", "targetAmount": 0.0, "deadline": "ISO8601", "description": "string?" }
```

**Response — Goal:**
```json
{
  "id": "string",
  "title": "string",
  "description": "string?",
  "targetAmount": 0.0,
  "currentAmount": 0.0,
  "deadline": "ISO8601",
  "status": "active|completed|cancelled",
  "createdAt": "ISO8601",
  "updatedAt": "ISO8601"
}
```

**Códigos de error:** `400` validación, `401` no autenticado, `404` meta no encontrada, `409` meta ya completada

## Estrategia de Cache Local

- **Box Hive:** `goals_box`
- **Clave:** `goal.id`
- **Política:** al abrir la pantalla se sirve desde caché inmediatamente y se lanza sync en background (stale-while-revalidate)
- **Invalidación:** al crear, actualizar, agregar progreso o eliminar → actualizar entry en caché local
- **Adapter Hive:** registrar `GoalModelAdapter` en `LocalStorageServiceImpl.init()`

## Pantallas UI

| Pantalla | Ruta | Entrada | Salida |
|----------|------|---------|--------|
| **GoalsListPage** | `/goals` | Tab de navegación | GoalDetailPage, GoalFormPage |
| **GoalFormPage** | `/goals/new` y `/goals/:id/edit` | FAB / botón editar | Vuelve a GoalsListPage |
| **GoalDetailPage** | `/goals/:id` | Tap en lista | GoalFormPage (editar), diálogo progreso |

- `GoalsListPage`: lista de metas con barra de progreso (`LinearProgressIndicator`), chip de status, FAB para crear nueva
- `GoalFormPage`: formulario unificado para crear y editar (recibe `goalId?` opcional)
- `GoalDetailPage`: monto acumulado vs objetivo, días restantes, botón "Agregar abono", botones completar/cancelar

## Consideraciones de Seguridad

- Los montos (`targetAmount`, `currentAmount`) **nunca** se registran en logs — el `LoggingInterceptor` solo loguea URL + status (ya configurado)
- No exponer montos en mensajes de error que lleguen al usuario
- Validar `amount > 0` en el use case **antes** de llamar al repositorio (no solo en UI)

## Fuera del Alcance (Piloto)

- Historial detallado de abonos (solo se muestra el progreso acumulado)
- Notificaciones push cuando una meta está por vencer
- Metas compartidas entre usuarios
- Categorías o etiquetas de metas
- Imágenes o íconos personalizados por meta
- Exportar metas a PDF/CSV
