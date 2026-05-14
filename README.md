# Nagaro

App móvil de control de gastos bancarios. Piloto Android-first.

## Stack

- **Flutter** — UI multiplataforma
- **Riverpod** — estado y dependency injection
- **GoRouter** — navegación declarativa
- **Dio** — cliente HTTP con interceptores
- **Hive CE** — caché local
- **Freezed** — modelos inmutables

## Arquitectura

Feature-first Clean Architecture: cada feature tiene sus capas `domain/`, `data/` y `presentation/` aisladas. Los widgets reutilizables viven en `lib/shared/widgets/` siguiendo Atomic Design (atoms + molecules).

## Desarrollo

El proyecto sigue **SDD (Specification-Driven Development)**. Antes de codificar cualquier feature, se crea su spec:

```bash
# 1. Crear spec del feature
/spec <feature>

# 2. Scaffoldear el feature
/feature <feature>

# 3. Para widgets nuevos, verificar primero si ya existe uno similar
/widget <Nombre> --type atom|molecule

# 4. Regenerar código después de cambios en modelos o providers
dart run build_runner build --delete-conflicting-outputs

# 5. Verificar
flutter analyze
```

Ver [docs/DEVELOPMENT_GUIDE.md](docs/DEVELOPMENT_GUIDE.md) para el detalle completo de cada comando.

## Requisitos

- Flutter SDK `^3.11.5`
- Android Studio / emulador Android para desarrollo local
