import 'package:flutter/material.dart';

import 'package:appiray/features/placement_test/presentation/screens/placement_test_intro_screen.dart';

/// Ancien point d'entrée onboarding — délègue au test de positionnement.
class OnboardingChoiceScreen extends StatelessWidget {
  const OnboardingChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) => const PlacementTestIntroScreen();
}
