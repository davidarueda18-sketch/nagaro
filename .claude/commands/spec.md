# /spec — Puerta SDD: Crear especificación de feature

Eres el escritor de especificaciones para Nagaro. Antes de escribir cualquier código para un feature, debe existir una spec aprobada. Este es el gate del proceso SDD.

## Argumentos

`$ARGUMENTS` contiene el nombre del feature en snake_case (ej: `auth`, `transactions`, `dashboard`).

## Tu tarea

1. Verifica si `docs/specs/$ARGUMENTS.md` ya existe.
   - Si existe: muestra su contenido y pide al desarrollador que confirme que sigue vigente antes de continuar.
   - Si NO existe: crea el archivo con la estructura exacta de abajo.

2. Crea `docs/specs/$ARGUMENTS.md` con esta estructura:

```markdown
# Feature Spec: [NombreDelFeature]

## Status
- [ ] Spec aprobada
- [ ] Capa domain completa
- [ ] Capa data completa
- [ ] Capa presentation completa
- [ ] Tests escritos
- [ ] Feature revisado

## Overview
[Un párrafo describiendo qué hace este feature y por qué existe en Nagaro.]

## User Stories
- Como usuario, quiero [acción] para [resultado].

## Domain Entities
Para cada entidad que este feature posee:
- **NombreEntidad**: campos, constraints, relaciones

## Use Cases
Lista cada use case con inputs y outputs/failures esperados:
- **NombreCaso(input: Type): (OutputType?, Failure?)**

## Repository Interface (Abstract)
```dart
abstract interface class [Feature]Repository {
  // firmas de métodos
}
```

## API Contract (si aplica)
- Endpoint, método HTTP, request body, response shape, códigos de error

## Estrategia de Cache Local
- Qué se cachea, patrón de clave, TTL / política de invalidación

## Pantallas UI
- Nombre de pantalla, propósito, puntos de entrada/salida de navegación

## Consideraciones de Seguridad
- Qué datos son sensibles, cómo se almacenan, qué NUNCA va en logs

## Fuera del Alcance (Piloto)
- Lista explícita de qué NO se construye ahora
```

3. Después de crear el archivo, imprime:
   "Spec creada en docs/specs/$ARGUMENTS.md. Revisa y edita la spec antes de ejecutar /feature $ARGUMENTS."

## Reglas
- NO generes ningún código Dart en este comando.
- El archivo spec debe ser revisado y aprobado manualmente antes de ejecutar /feature.
- Marca el checkbox "Spec aprobada" solo cuando el desarrollador confirme explícitamente.
