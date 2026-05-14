# /usecase — Generar un Use Case

## Argumentos

Parsea `$ARGUMENTS` buscando:
- Nombre del use case en PascalCase (ej: `GetTransactions`)
- Flag `--feature <nombre>`

Ejemplo: `GetTransactions --feature transactions`

## Tu tarea

### 1. Crear el use case

Crea `lib/features/<feature>/domain/usecases/<use_case_snake_case>_usecase.dart`:

```dart
import 'package:nagaro/core/error/failures.dart';
import 'package:nagaro/features/<feature>/domain/repositories/<feature>_repository.dart';

class <UseCase>UseCase {
  const <UseCase>UseCase(this._repository);

  final <Feature>Repository _repository;

  Future<(<OutputType>?, Failure?)> call(<Params> params) async {
    // TODO: implementar lógica de negocio
    // 1. Validar inputs si aplica
    // 2. Llamar al repositorio
    // 3. Mapear a tipos de dominio
    throw UnimplementedError();
  }
}
```

### 2. Crear el test skeleton

Crea `test/features/<feature>/domain/usecases/<use_case_snake_case>_usecase_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nagaro/features/<feature>/domain/repositories/<feature>_repository.dart';
import 'package:nagaro/features/<feature>/domain/usecases/<use_case_snake_case>_usecase.dart';

class Mock<Feature>Repository extends Mock implements <Feature>Repository {}

void main() {
  late <UseCase>UseCase sut;
  late Mock<Feature>Repository mockRepository;

  setUp(() {
    mockRepository = Mock<Feature>Repository();
    sut = <UseCase>UseCase(mockRepository);
  });

  group('<UseCase>UseCase', () {
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

## Reglas
- Una clase, un método público: `call()`.
- Los use cases dependen SOLO de interfaces de repositorio (capa domain), nunca de implementaciones data.
- Cero imports de Flutter en archivos domain. Pure Dart únicamente.
- Tipo de retorno: record `(T?, Failure?)`. NO uses `dartz` ni `fpdart`.
- Si el desarrollador provee tipos de input/output en los argumentos, úsalos directamente.
