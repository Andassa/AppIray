import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:appiray/core/providers/core_providers.dart';
import 'package:appiray/core/router/route_paths.dart';
import 'package:appiray/features/placement_test/domain/placement_entities.dart';

/// Résultat du test : bonnes réponses + unités débloquées → home.
class PlacementTestResultScreen extends ConsumerWidget {
  const PlacementTestResultScreen({
    super.key,
    required this.courseId,
    required this.result,
  });

  final String courseId;
  final PlacementResult result;

  Future<void> _continue(BuildContext context, WidgetRef ref) async {
    await ref.read(localCacheServiceProvider).setPlacementTestSeen(true);
    if (!context.mounted) return;
    context.go(RoutePaths.home);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Le backend renvoie correct_count + units_unlocked (pas de libellé "niveau").
    final levelLabel = result.unitsUnlocked > 0
        ? 'Niveau estimé : ${result.unitsUnlocked} unité(s) débloquée(s)'
        : 'Niveau estimé : débutant';

    return Scaffold(
      appBar: AppBar(title: const Text('Résultat')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                'Test terminé',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                levelLabel,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Bonnes réponses : ${result.correctCount}',
                textAlign: TextAlign.center,
              ),
              Text(
                'Unités débloquées : ${result.unitsUnlocked}',
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              FilledButton(
                key: const Key('placement_result_continue'),
                onPressed: () => _continue(context, ref),
                child: const Text('Continuer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
