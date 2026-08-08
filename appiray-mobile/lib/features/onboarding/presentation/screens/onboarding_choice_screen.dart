import 'package:flutter/material.dart';

/// Écran de choix d'onboarding (niveau / objectif). Structure seulement —
/// contenu et logique réels à brancher plus tard (placement test, etc.).
class OnboardingChoiceScreen extends StatelessWidget {
  const OnboardingChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bienvenue')),
      body: const SafeArea(
        child: Center(child: Text('Choix d\'onboarding (à brancher).')),
      ),
    );
  }
}
