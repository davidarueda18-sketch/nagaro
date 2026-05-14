# /page — Generar Page + Riverpod Notifier

## Argumentos

Parsea `$ARGUMENTS` buscando:
- Nombre de la página en PascalCase (ej: `TransactionDetail`)
- Flag `--feature <nombre>`

Ejemplo: `TransactionDetail --feature transactions`

## Tu tarea

### 0. Design System Check (obligatorio antes de generar código)

Muestra al desarrollador el inventario actual del design system:

```
DESIGN SYSTEM — lib/shared/widgets/
Import único: import 'package:nagaro/shared/widgets/widgets.dart';

ATOMS
  buttons/   NagaroPrimaryButton, NagaroGhostButton
  display/   AmountText (con AmountPolarity, AmountSize), StatusBadge (con BadgeVariant), AppLogo
  feedback/  NagaroLoadingIndicator, EmptyState, ErrorMessage
  inputs/    NagaroTextField
  layout/    SectionHeader

MOLECULES
  cards/     TransactionCard, GoalProgressCard, SummaryCard
  forms/     LabeledTextField
```

Luego imprime:

> "Design System Check para `<Page>Page`:
> ¿Los elementos visuales de esta página pueden construirse con los widgets de arriba?
>
> - **SÍ** → úsalos directamente con `import 'package:nagaro/shared/widgets/widgets.dart';`
> - **NO** → ejecuta `/widget <Nombre> --type atom|molecule` primero para agregar el widget al design system, luego vuelve a `/page`."

Continúa con los pasos siguientes solo después de que el desarrollador confirme que revisó el design system.

---

### 1. Crear el provider / notifier

Crea `lib/features/<feature>/presentation/providers/<page_snake_case>_provider.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part '<page_snake_case>_provider.freezed.dart';
part '<page_snake_case>_provider.g.dart';

@freezed
class <Page>State with _$<Page>State {
  const factory <Page>State({
    @Default(false) bool isLoading,
    // TODO: agregar campos de estado
  }) = _<Page>State;
}

@riverpod
class <Page>Notifier extends _$<Page>Notifier {
  @override
  <Page>State build() {
    return const <Page>State();
  }

  // TODO: agregar métodos que mapean acciones del usuario
}
```

### 2. Crear la página

Crea `lib/features/<feature>/presentation/pages/<page_snake_case>_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nagaro/features/<feature>/presentation/providers/<page_snake_case>_provider.dart';

class <Page>Page extends ConsumerWidget {
  const <Page>Page({super.key});

  static const routePath = '/<page_snake_case>';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(<page_camelCase>NotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('<Page>')),
      body: switch (state.isLoading) {
        true => const Center(child: CircularProgressIndicator()),
        false => const _<Page>Body(),
      },
    );
  }
}

class _<Page>Body extends StatelessWidget {
  const _<Page>Body();

  @override
  Widget build(BuildContext context) {
    // TODO: usar widgets de lib/shared/widgets/widgets.dart antes de crear widgets inline
    // Si necesitas un widget nuevo: /widget <Nombre> --type atom|molecule
    return const Placeholder();
  }
}
```

### 3. Recordatorio de ruta

Imprime al desarrollador:
```dart
// Agrega esta ruta en lib/core/router/app_router.dart:
GoRoute(
  path: <Page>Page.routePath,
  builder: (context, state) => const <Page>Page(),
),
```

### 4. Widget test skeleton

Crea `test/features/<feature>/presentation/pages/<page_snake_case>_page_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nagaro/features/<feature>/presentation/pages/<page_snake_case>_page.dart';

void main() {
  testWidgets('<Page>Page renderiza sin errores', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: <Page>Page()),
      ),
    );
    expect(find.byType(<Page>Page), findsOneWidget);
  });
}
```

## Reglas
- Toda página es `ConsumerWidget` o `ConsumerStatefulWidget`. NUNCA `StatefulWidget` con estado mutable.
- Ninguna lógica de negocio en el método `build()`. La lógica vive en el Notifier.
- Los archivos de provider siempre en `presentation/providers/`, nunca co-ubicados en el archivo de la página.
- Ejecuta build_runner después de crear cualquier archivo provider.
