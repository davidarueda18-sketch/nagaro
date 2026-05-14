# /feature — Scaffoldear un feature completo (Clean Architecture)

Scaffoldeas el skeleton completo de un feature siguiendo el patrón Clean Architecture de Nagaro.

## Argumentos

`$ARGUMENTS` contiene el nombre del feature en snake_case (ej: `transactions`, `auth`).

## Verificación previa (SDD Gate)

Antes de generar cualquier código:

1. Verifica que exista `docs/specs/$ARGUMENTS.md`. Si NO existe, rechaza con:
   > "No existe spec para '$ARGUMENTS'. Ejecuta `/spec $ARGUMENTS` primero. Este proyecto usa SDD — ningún feature sin spec aprobada."

2. Lee la spec y úsala para inferir nombres de entidades, use cases y firmas del repositorio.

## Archivos a crear

Crea TODOS los siguientes archivos con el skeleton indicado. Usa la spec para reemplazar los placeholders `[Feature]`, `[Entity]`, `[UseCase]` con nombres reales.

### Domain Layer

**`lib/features/$ARGUMENTS/domain/entities/[entity].dart`**
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part '[entity].freezed.dart';

@freezed
class [Entity] with _$[Entity] {
  const factory [Entity]({
    required String id,
    // TODO: campos según spec
  }) = _[Entity];
}
```

**`lib/features/$ARGUMENTS/domain/repositories/[feature]_repository.dart`**
```dart
import 'package:nagaro/core/error/failures.dart';

abstract interface class [Feature]Repository {
  // TODO: firmas de métodos según spec
}
```

**`lib/features/$ARGUMENTS/domain/usecases/[usecase]_usecase.dart`** (uno por use case en la spec)
```dart
import 'package:nagaro/core/error/failures.dart';
import 'package:nagaro/features/$ARGUMENTS/domain/repositories/[feature]_repository.dart';

class [UseCase]UseCase {
  const [UseCase]UseCase(this._repository);

  final [Feature]Repository _repository;

  Future<([OutputType]?, Failure?)> call([InputType] params) async {
    throw UnimplementedError();
  }
}
```

### Data Layer

**`lib/features/$ARGUMENTS/data/models/[entity]_model.dart`**
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nagaro/features/$ARGUMENTS/domain/entities/[entity].dart';

part '[entity]_model.freezed.dart';
part '[entity]_model.g.dart';

@freezed
class [Entity]Model with _$[Entity]Model {
  const factory [Entity]Model({
    @JsonKey(name: 'id') required String id,
    // TODO: campos según API contract en spec
  }) = _[Entity]Model;

  factory [Entity]Model.fromJson(Map<String, dynamic> json) =>
      _$[Entity]ModelFromJson(json);
}

extension [Entity]ModelMapper on [Entity]Model {
  [Entity] toEntity() => [Entity](id: id);
}
```

**`lib/features/$ARGUMENTS/data/datasources/[feature]_remote_datasource.dart`**
```dart
import 'package:dio/dio.dart';

abstract interface class [Feature]RemoteDataSource {
  // TODO: firmas de métodos
}

class [Feature]RemoteDataSourceImpl implements [Feature]RemoteDataSource {
  const [Feature]RemoteDataSourceImpl(this._dio);

  final Dio _dio;

  // TODO: implementar
}
```

**`lib/features/$ARGUMENTS/data/datasources/[feature]_local_datasource.dart`**
```dart
abstract interface class [Feature]LocalDataSource {
  // TODO: firmas de métodos
}

class [Feature]LocalDataSourceImpl implements [Feature]LocalDataSource {
  // TODO: inyectar Hive box
  // TODO: implementar
}
```

**`lib/features/$ARGUMENTS/data/repositories/[feature]_repository_impl.dart`**
```dart
import 'package:nagaro/core/error/failures.dart';
import 'package:nagaro/features/$ARGUMENTS/domain/repositories/[feature]_repository.dart';
import 'package:nagaro/features/$ARGUMENTS/data/datasources/[feature]_remote_datasource.dart';
import 'package:nagaro/features/$ARGUMENTS/data/datasources/[feature]_local_datasource.dart';

class [Feature]RepositoryImpl implements [Feature]Repository {
  const [Feature]RepositoryImpl({
    required [Feature]RemoteDataSource remoteDataSource,
    required [Feature]LocalDataSource localDataSource,
  });

  // TODO: implementar
}
```

### Presentation Layer

**`lib/features/$ARGUMENTS/presentation/providers/[feature]_provider.dart`**
```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '[feature]_provider.g.dart';

@riverpod
class [Feature]Notifier extends _$[Feature]Notifier {
  @override
  // TODO: definir tipo de estado e implementar build()
  FutureOr<void> build() async {}
}
```

**`lib/features/$ARGUMENTS/presentation/pages/[feature]_page.dart`**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class [Feature]Page extends ConsumerWidget {
  const [Feature]Page({super.key});

  static const routePath = '/[feature]';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('[Feature]')),
      body: const Center(child: Text('[Feature] — TODO')),
    );
  }
}
```

### Tests

**`test/features/$ARGUMENTS/domain/usecases/[usecase]_usecase_test.dart`**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nagaro/features/$ARGUMENTS/domain/repositories/[feature]_repository.dart';
import 'package:nagaro/features/$ARGUMENTS/domain/usecases/[usecase]_usecase.dart';

class Mock[Feature]Repository extends Mock implements [Feature]Repository {}

void main() {
  late [UseCase]UseCase sut;
  late Mock[Feature]Repository mockRepository;

  setUp(() {
    mockRepository = Mock[Feature]Repository();
    sut = [UseCase]UseCase(mockRepository);
  });

  group('[UseCase]UseCase', () {
    test('retorna resultado exitoso', () async {
      // arrange
      // act
      // assert
    });

    test('retorna Failure en error', () async {
      // arrange
      // act
      // assert
    });
  });
}
```

## Después de crear los archivos

Imprime una tabla resumen:
| Capa | Archivo | Estado |
|------|---------|--------|
| domain/entities | ... | Creado |
...

Luego imprime:
```
Ejecuta: dart run build_runner build --delete-conflicting-outputs
Siguiente: completa los TODOs en cada archivo. Usa /usecase, /model, /page para adiciones incrementales.
```

## Reglas
- Las entidades de domain son Freezed-only. NUNCA tienen json_serializable.
- Los modelos de data tienen Freezed + json_serializable + mapper extension.
- Domain = Pure Dart: cero imports de `dio`, `hive`, `flutter` en archivos domain.
- Un use case, un `call()`.
