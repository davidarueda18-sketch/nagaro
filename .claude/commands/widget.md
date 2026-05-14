# /widget — Crear o reutilizar un widget del design system

## Argumentos

Parsea `$ARGUMENTS` buscando:
- Nombre del widget en PascalCase (ej: `TransactionCard`, `PrimaryButton`)
- Flag `--type atom|molecule` (obligatorio)
- Flag `--feature <nombre>` (opcional — solo si el widget pertenece a un feature específico)

Ejemplos:
```
/widget AmountText --type atom
/widget GoalProgressCard --type molecule
/widget BankAccountSelector --type molecule --feature accounts
```

---

## Paso 1 — Inventario del design system (SIEMPRE primero)

Antes de generar cualquier código, muestra al desarrollador el inventario completo actual:

```
DESIGN SYSTEM — lib/shared/widgets/

ATOMS
  buttons/   NagaroPrimaryButton, NagaroGhostButton
  display/   AmountText, StatusBadge, AppLogo
  feedback/  NagaroLoadingIndicator, EmptyState, ErrorMessage
  inputs/    NagaroTextField
  layout/    SectionHeader

MOLECULES
  cards/     TransactionCard, GoalProgressCard, SummaryCard
  forms/     LabeledTextField
```

Luego pregunta:

> "¿`<Nombre>` podría ser uno de estos widgets, o una variante/extensión de alguno?
> Responde con el nombre del widget candidato, o escribe `nuevo` para crear uno desde cero."

---

## Paso 2a — Si existe un widget reutilizable

Muestra:
1. Path exacto del archivo
2. Constructor completo con todos sus parámetros
3. Ejemplo de uso mínimo en contexto

Ejemplo para `AmountText`:
```dart
// Import único necesario:
import 'package:nagaro/shared/widgets/widgets.dart';

// Uso básico (balance neutral)
AmountText(amount: 150000)

// Gasto con signo
AmountText(
  amount: 75000,
  polarity: AmountPolarity.expense,
  showSign: true,
)

// Ingreso grande en dashboard
AmountText(
  amount: 2500000,
  polarity: AmountPolarity.income,
  size: AmountSize.large,
)
```

### Si necesita un prop extra menor

Pregunta:
> "¿Agrego `<prop>` al widget existente en shared, o prefieres un wrapper local en el feature?"

**Agrega al widget existente** si el prop es genérico y beneficia a otros usos.
**Crea un wrapper en el feature** si el prop es muy específico del contexto o rompe la API existente. El wrapper va en `lib/features/<feature>/presentation/widgets/<nombre>_widget.dart`.

---

## Paso 2b — Si es un widget nuevo

### Decisión de ubicación

| Situación | Destino |
|-----------|---------|
| Widget genérico, sin lógica de negocio, sin `ref` | `lib/shared/widgets/<tipo>/<subcarpeta>/` |
| Widget con `ref` o accede a providers | `lib/features/<feature>/presentation/widgets/` |
| Widget muy específico de un feature | `lib/features/<feature>/presentation/widgets/` |

Si el widget necesita `ref`, informa al desarrollador:
> "Este widget requiere acceso a providers — irá en `lib/features/<feature>/presentation/widgets/` en lugar de shared."

### Subcarpetas para atoms

| Subcarpeta | Contenido |
|------------|-----------|
| `buttons/` | Elementos interactivos tipo botón |
| `display/` | Texto, badges, avatares, iconos decorativos |
| `feedback/` | Loading, error, empty state |
| `inputs/` | Campos de texto, selects, sliders |
| `layout/` | Headers de sección, separadores semánticos |

### Subcarpetas para molecules

| Subcarpeta | Contenido |
|------------|-----------|
| `cards/` | Tarjetas que agrupan información |
| `forms/` | Grupos de inputs con labels y validación |
| `lists/` | Ítems de lista compuestos (crear solo si se necesita) |

### Template atom

```dart
import 'package:flutter/material.dart';
import 'package:nagaro/core/theme/theme.dart';

class <Nombre> extends StatelessWidget {
  const <Nombre>({
    super.key,
    // props requeridas primero, opcionales con default después
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder(); // TODO: implementar
  }
}
```

### Template molecule

```dart
import 'package:flutter/material.dart';
import 'package:nagaro/core/theme/theme.dart';
import 'package:nagaro/shared/widgets/widgets.dart';

class <Nombre> extends StatelessWidget {
  const <Nombre>({
    super.key,
    // props requeridas primero, opcionales con default después
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder(); // TODO: implementar
  }
}
```

### Después de crear el archivo

1. Agrega el export al barrel `lib/shared/widgets/widgets.dart` en la sección correspondiente
2. Actualiza el inventario de este skill en el bloque del Paso 1
3. Imprime:

```
✓ Widget creado: lib/shared/widgets/<tipo>/<subcarpeta>/<nombre_snake>.dart
✓ Export agregado en: lib/shared/widgets/widgets.dart

Para usarlo en cualquier archivo:
  import 'package:nagaro/shared/widgets/widgets.dart';
```

---

## Reglas absolutas

- `StatelessWidget` siempre en shared. Si un widget importa `flutter_riverpod` → va en presentation del feature.
- Cero imports de `lib/features/*/` en archivos de `lib/shared/`.
- Cero lógica de negocio en widgets shared. Solo composición visual.
- Molecules solo componen atoms de shared o widgets nativos Flutter. Nunca lógica de formato de datos.
- El formateo de moneda (`CurrencyFormatter`) vive en `AmountText`. No replicarlo en molecules ni pages.
- Props opcionales siempre con valor por defecto. Minimizar props requeridas.
- No hardcodear colores ni tamaños: usar `AppColors`, `AppSpacing`, `AppRadius`, `AppTextStyles`.
- No crear `ThemeExtension` ni `InheritedWidget` custom — diferido para cuando llegue dark mode.
