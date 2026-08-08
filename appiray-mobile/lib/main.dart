import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:appiray/app.dart';
import 'package:appiray/core/providers/core_providers.dart';
import 'package:appiray/core/session/session_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init des dépendances async avant le premier frame.
  final prefs = await SharedPreferences.getInstance();

  final container = ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
  );

  // Détermine l'état d'auth initial (tokens présents ?) avant d'afficher l'UI.
  await container.read(sessionControllerProvider.notifier).bootstrap();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const AppIrayApp(),
    ),
  );
}
