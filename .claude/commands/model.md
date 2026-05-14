# /model — Generar un Freezed Model + Domain Entity

## Argumentos

Parsea `$ARGUMENTS` buscando:
- Nombre del modelo en PascalCase (primer token)
- Flag `--feature <nombre>` para el feature destino

Ejemplo: `Transaction --feature transactions`

## Tu tarea

### 1. Crear el modelo de datos

Crea `lib/features/<feature>/data/models/<model_snake_case>_model.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nagaro/features/<feature>/domain/entities/<entity_snake_case>.dart';

part '<model_snake_case>_model.freezed.dart';
part '<model_snake_case>_model.g.dart';

@freezed
class <Model>Model with _$<Model>Model {
  const factory <Model>Model({
    @JsonKey(name: 'id') required String id,
    // TODO: agregar campos — solicitar lista al desarrollador si no están en los argumentos
  }) = _<Model>Model;

  factory <Model>Model.fromJson(Map<String, dynamic> json) =>
      _$<Model>ModelFromJson(json);
}

extension <Model>ModelMapper on <Model>Model {
  <Model> toEntity() => <Model>(id: id);
}
```

### 2. Crear la entidad de dominio (si no existe)

Crea `lib/features/<feature>/domain/entities/<entity_snake_case>.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part '<entity_snake_case>.freezed.dart';

@freezed
class <Model> with _$<Model> {
  const factory <Model>({
    required String id,
    // TODO: reflejar campos del modelo
  }) = _<Model>;
}
```

### 3. Recordatorio

Después de crear, imprime:
```
Ejecuta: dart run build_runner build --delete-conflicting-outputs
```

## Reglas estrictas
- NUNCA pongas `json_serializable` en entidades de dominio. Solo los modelos data reciben `@JsonKey` y `fromJson`.
- Los nombres de modelo DEBEN terminar en sufijo `Model`.
- Los nombres de entidad NUNCA llevan sufijo `Model`.
- El mapper extension vive en el archivo del modelo, no en el de la entidad.
- Si el desarrollador provee campos explícitos en los argumentos, úsalos directamente en lugar de poner TODOs.
