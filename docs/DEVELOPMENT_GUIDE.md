# Guía de Desarrollo — Nagaro

Esta guía describe el flujo de desarrollo basado en **SDD (Specification-Driven Development)** implementado en Nagaro mediante Claude Code skills. Todos los comandos están disponibles como slash commands dentro de Claude Code.

---

## Filosofía del patrón

Nagaro sigue una regla fundamental: **ningún feature se codifica sin una especificación aprobada primero**. El comando `/spec` actúa como puerta obligatoria que el comando `/feature` verifica mecánicamente antes de generar cualquier código.

El flujo siempre es:

```
/spec <feature>  →  revisar y aprobar spec  →  /feature <feature>  →  implementar TODOs
```

Para adiciones incrementales dentro de un feature ya scaffoldeado:

```
/model   →  /usecase   →  /page
```

---

## Comandos disponibles

### `/spec <feature>`

**Propósito:** Crear la especificación de un feature antes de escribir cualquier línea de código.

**Archivo:** `.claude/commands/spec.md`

**Uso:**
```
/spec auth
/spec transactions
/spec dashboard
```

**Qué hace:**
- Verifica si ya existe `docs/specs/<feature>.md`
- Si no existe, crea el archivo con una plantilla estructurada que incluye: overview, user stories, entidades de dominio, use cases, interfaz del repositorio, contrato de API, estrategia de caché, pantallas UI, consideraciones de seguridad y alcance del piloto
- Si ya existe, muestra el contenido actual y pide confirmación de vigencia

**Output esperado:**
```
Spec creada en docs/specs/auth.md.
Revisa y edita la spec antes de ejecutar /feature auth.
```

**Reglas:**
- No genera ningún código Dart
- El archivo spec debe ser revisado y editado manualmente antes de continuar
- Marca el checkbox `- [x] Spec aprobada` en el archivo cuando estés listo para codificar

**Ejemplo de spec generada:** `docs/specs/auth.md`

---

### `/feature <feature>`

**Propósito:** Scaffoldear el skeleton completo de un feature siguiendo Clean Architecture.

**Archivo:** `.claude/commands/feature.md`

**Uso:**
```
/feature auth
/feature transactions
/feature dashboard
```

**Precondición obligatoria:** debe existir `docs/specs/<feature>.md`. Si no existe, el comando rechaza con:
```
No existe spec para 'auth'. Ejecuta /spec auth primero.
Este proyecto usa SDD — ningún feature sin spec aprobada.
```

**Qué genera:**

```
lib/features/<feature>/
├── domain/
│   ├── entities/
│   │   └── <entity>.dart               # Freezed entity (pure Dart)
│   ├── repositories/
│   │   └── <feature>_repository.dart   # Interfaz abstracta
│   └── usecases/
│       └── <usecase>_usecase.dart      # Un archivo por use case
├── data/
│   ├── models/
│   │   └── <entity>_model.dart         # Freezed + json_serializable + mapper
│   ├── datasources/
│   │   ├── <feature>_remote_datasource.dart
│   │   └── <feature>_local_datasource.dart
│   └── repositories/
│       └── <feature>_repository_impl.dart
└── presentation/
    ├── providers/
    │   └── <feature>_provider.dart     # @riverpod Notifier
    └── pages/
        └── <feature>_page.dart         # ConsumerWidget

test/features/<feature>/
└── domain/usecases/
    └── <usecase>_usecase_test.dart     # Skeleton con mocktail
```

**Después de ejecutar:**
```bash
dart run build_runner build --delete-conflicting-outputs
```

**Qué completar manualmente (TODOs):**
1. Campos de las entidades y modelos según la spec
2. Firmas de métodos en el repositorio abstracto
3. Lógica de los use cases
4. Implementación de datasources (llamadas Dio / Hive)
5. Estado y métodos del Notifier
6. UI de las páginas

---

### `/model <Nombre> --feature <feature>`

**Propósito:** Generar un modelo Freezed (data layer) y su entidad de dominio correspondiente.

**Archivo:** `.claude/commands/model.md`

**Uso:**
```
/model Transaction --feature transactions
/model BankAccount --feature accounts
/model Category --feature categories
```

**Qué genera:**

`lib/features/<feature>/data/models/transaction_model.dart`
```dart
@freezed
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    @JsonKey(name: 'id') required String id,
    // campos según spec...
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
}

extension TransactionModelMapper on TransactionModel {
  Transaction toEntity() => Transaction(id: id);
}
```

`lib/features/<feature>/domain/entities/transaction.dart`
```dart
@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    // campos espejados del modelo...
  }) = _Transaction;
}
```

**Reglas que enforce:**
- Las entidades **nunca** tienen `@JsonKey` ni `fromJson` — solo Freezed
- Los modelos **siempre** tienen el sufijo `Model`
- Las entidades **nunca** tienen el sufijo `Model`
- El mapper `toEntity()` vive en el archivo del modelo, no en la entidad

**Después de ejecutar:**
```bash
dart run build_runner build --delete-conflicting-outputs
```

---

### `/usecase <NombreCaso> --feature <feature>`

**Propósito:** Generar una clase de use case y su test skeleton.

**Archivo:** `.claude/commands/usecase.md`

**Uso:**
```
/usecase GetTransactions --feature transactions
/usecase SignIn --feature auth
/usecase SyncTransactions --feature transactions
```

**Qué genera:**

`lib/features/<feature>/domain/usecases/get_transactions_usecase.dart`
```dart
class GetTransactionsUseCase {
  const GetTransactionsUseCase(this._repository);

  final TransactionsRepository _repository;

  Future<(List<Transaction>?, Failure?)> call(GetTransactionsParams params) async {
    // TODO: implementar
    throw UnimplementedError();
  }
}
```

`test/features/<feature>/domain/usecases/get_transactions_usecase_test.dart`
```dart
class MockTransactionsRepository extends Mock implements TransactionsRepository {}

void main() {
  late GetTransactionsUseCase sut;
  late MockTransactionsRepository mockRepository;

  setUp(() { ... });

  group('GetTransactionsUseCase', () {
    test('retorna resultado exitoso', ...);
    test('retorna Failure en error', ...);
  });
}
```

**Reglas que enforce:**
- Una clase, un método público: `call()`
- Cero imports de Flutter — pure Dart únicamente
- Solo depende de la interfaz del repositorio (domain), nunca de implementaciones (data)
- Tipo de retorno: record `(T?, Failure?)` — no se usa `dartz` ni `fpdart`

---

### `/page <NombrePagina> --feature <feature>`

**Propósito:** Generar una página Flutter con su Riverpod Notifier y widget test.

**Archivo:** `.claude/commands/page.md`

**Uso:**
```
/page TransactionDetail --feature transactions
/page Login --feature auth
/page Settings --feature settings
```

**Qué genera:**

`lib/features/<feature>/presentation/providers/transaction_detail_provider.dart`
```dart
@freezed
class TransactionDetailState with _$TransactionDetailState {
  const factory TransactionDetailState({
    @Default(false) bool isLoading,
    // campos de estado...
  }) = _TransactionDetailState;
}

@riverpod
class TransactionDetailNotifier extends _$TransactionDetailNotifier {
  @override
  TransactionDetailState build() => const TransactionDetailState();
  // métodos de acciones del usuario...
}
```

`lib/features/<feature>/presentation/pages/transaction_detail_page.dart`
```dart
class TransactionDetailPage extends ConsumerWidget {
  static const routePath = '/transaction_detail';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionDetailNotifierProvider);
    return Scaffold(...);
  }
}
```

`test/features/<feature>/presentation/pages/transaction_detail_page_test.dart`

**El comando también te recuerda** agregar la ruta en `lib/core/router/app_router.dart`.

**Reglas que enforce:**
- Toda página es `ConsumerWidget` o `ConsumerStatefulWidget` — nunca `StatefulWidget`
- Ninguna lógica de negocio en `build()` — toda la lógica vive en el Notifier
- Los providers siempre en `presentation/providers/`, nunca co-ubicados en la página

**Después de ejecutar:**
```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Flujo completo de ejemplo: feature `transactions`

```bash
# 1. Crear la spec (SDD gate)
/spec transactions

# 2. Editar docs/specs/transactions.md manualmente:
#    - Describir las entidades (Transaction, Category)
#    - Listar use cases (GetTransactions, GetTransactionById, SyncTransactions)
#    - Definir el contrato de la API
#    - Marcar: - [x] Spec aprobada

# 3. Scaffoldear el feature completo
/feature transactions

# 4. Correr codegen (obligatorio después de /feature)
dart run build_runner build --delete-conflicting-outputs

# 5. Agregar campos al modelo (si necesitas uno adicional)
/model Category --feature transactions

# 6. Agregar un use case adicional
/usecase FilterTransactionsByDate --feature transactions

# 7. Agregar una página adicional
/page TransactionDetail --feature transactions

# 8. Correr codegen nuevamente
dart run build_runner build --delete-conflicting-outputs

# 9. Verificar que no hay errores de análisis
flutter analyze

# 10. Correr los tests del feature
flutter test test/features/transactions/
```

---

## Límites de los comandos (qué NO hacen)

| Comando | No hace |
|---------|---------|
| `/spec` | No genera código Dart |
| `/feature` | No implementa la lógica de los TODOs |
| `/model` | No registra el adaptador Hive (debes hacerlo en `local_storage_service.dart`) |
| `/usecase` | No conecta el use case al provider de Riverpod |
| `/page` | No registra la ruta en `app_router.dart` (te lo recuerda pero no lo hace) |

---

## Reglas de arquitectura a respetar siempre

```
lib/features/*/domain/  →  Pure Dart únicamente
                            Cero imports de: dio, hive, flutter

Entidades               →  Freezed solo. Sin json_serializable.
Modelos                 →  Freezed + json_serializable + mapper extension.

Use cases               →  Un archivo = una clase = un call()
Páginas                 →  ConsumerWidget. Lógica solo en el Notifier.
Providers               →  Siempre en presentation/providers/, nunca en la página.
```

**Verificar boundaries después de cada feature:**
```bash
# Debe retornar cero resultados
grep -r "import 'package:dio" lib/features/*/domain/
grep -r "import 'package:hive" lib/features/*/domain/
grep -r "import 'package:flutter" lib/features/*/domain/
```

---

## Comandos de mantenimiento frecuentes

```bash
# Regenerar código después de cambiar modelos o providers
dart run build_runner build --delete-conflicting-outputs

# Análisis estático completo
flutter analyze

# Correr todos los tests
flutter test

# Correr tests de un feature específico
flutter test test/features/auth/

# Levantar la app en el emulador
flutter run -d emulator-5554
```
