import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appiray/core/router/app_router.dart';
import 'package:appiray/core/theme/app_theme.dart';

/// Racine de l'application. Branche le router et le thème (placeholder).
class AppIrayApp extends ConsumerWidget {
  const AppIrayApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'AppIray',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: router,
    );
  }
}
