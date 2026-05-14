import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nagaro/core/constants/route_names.dart';
import 'package:nagaro/core/security/secure_storage_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

// ---------------------------------------------------------------------------
// Placeholder pages — will be replaced when features are scaffolded
// ---------------------------------------------------------------------------

class _SplashPage extends StatelessWidget {
  const _SplashPage();
  @override
  Widget build(BuildContext context) => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
}

class _LoginPage extends StatelessWidget {
  const _LoginPage();
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Text(
            'Login — usa /spec auth && /feature auth',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
}

class _DashboardPage extends StatelessWidget {
  const _DashboardPage();
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Nagaro')),
        body: const Center(child: Text('Dashboard — TODO')),
      );
}

// ---------------------------------------------------------------------------
// Secure storage provider (global singleton)
// ---------------------------------------------------------------------------

@riverpod
SecureStorageService secureStorage(Ref ref) => SecureStorageServiceImpl();

// ---------------------------------------------------------------------------
// Router
// ---------------------------------------------------------------------------

@riverpod
GoRouter appRouter(Ref ref) {
  final secureStorage = ref.watch(secureStorageProvider);

  return GoRouter(
    initialLocation: RouteNames.splash,
    redirect: (BuildContext context, GoRouterState state) async {
      final token = await secureStorage.readToken();
      final isAuthenticated = token != null && token.isNotEmpty;
      final isGoingToLogin = state.matchedLocation == RouteNames.login;
      final isOnSplash = state.matchedLocation == RouteNames.splash;

      if (isOnSplash) {
        return isAuthenticated ? RouteNames.dashboard : RouteNames.login;
      }
      if (!isAuthenticated && !isGoingToLogin) return RouteNames.login;
      if (isAuthenticated && isGoingToLogin) return RouteNames.dashboard;
      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const _SplashPage(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const _LoginPage(),
      ),
      GoRoute(
        path: RouteNames.dashboard,
        builder: (context, state) => const _DashboardPage(),
      ),
    ],
  );
}
