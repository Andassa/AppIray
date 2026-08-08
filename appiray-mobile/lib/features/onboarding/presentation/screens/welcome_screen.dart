import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:appiray/core/router/route_paths.dart';

/// Écran d'accueil (non authentifié). Structure minimale.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('AppIray'),
                const SizedBox(height: 8),
                const Text('Apprends le malgache'),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => context.go(RoutePaths.login),
                  child: const Text('Se connecter'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => context.go(RoutePaths.register),
                  child: const Text('Créer un compte'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
