import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nagaro/core/router/app_router.dart';
import 'package:nagaro/core/theme/app_theme.dart';

class NagaroApp extends ConsumerWidget {
  const NagaroApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'Nagaro',
      theme: AppTheme.light,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
