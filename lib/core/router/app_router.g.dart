// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$secureStorageHash() => r'289f0ff535e871d87c6cff3abfaa3408759f9684';

/// See also [secureStorage].
@ProviderFor(secureStorage)
final secureStorageProvider =
    AutoDisposeProvider<SecureStorageService>.internal(
      secureStorage,
      name: r'secureStorageProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$secureStorageHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SecureStorageRef = AutoDisposeProviderRef<SecureStorageService>;
String _$appRouterHash() => r'07f842eed468203a64a785825cc55cd7812b2480';

/// See also [appRouter].
@ProviderFor(appRouter)
final appRouterProvider = AutoDisposeProvider<GoRouter>.internal(
  appRouter,
  name: r'appRouterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appRouterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppRouterRef = AutoDisposeProviderRef<GoRouter>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
