import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appiray/features/progress/presentation/controllers/progress_controller.dart';

/// Progression : XP, streak, cœurs, gemmes, objectif quotidien. UI minimale.
class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(progressControllerProvider);
    final controller = ref.read(progressControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Progression')),
      body: SafeArea(
        child: asyncState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('$e', textAlign: TextAlign.center),
            ),
          ),
          data: (state) => ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ListTile(
                title: const Text('XP total'),
                trailing: Text('${state.user.xpTotal}'),
              ),
              ListTile(
                title: const Text('Série (streak)'),
                trailing: Text('${state.user.currentStreak} jours'),
              ),
              ListTile(
                title: const Text('Cœurs'),
                trailing:
                    Text('${state.hearts.hearts} / ${state.hearts.maxHearts}'),
              ),
              ListTile(
                title: const Text('Gemmes'),
                trailing: Text('${state.hearts.gems}'),
              ),
              ListTile(
                title: const Text('Objectif quotidien'),
                trailing: Text('${state.user.dailyXpGoal} XP'),
              ),
              const Divider(),
              Wrap(
                spacing: 8,
                children: [
                  FilledButton.tonal(
                    onPressed: controller.refillHeartsWithGems,
                    child: const Text('Recharger cœurs (gemmes)'),
                  ),
                  FilledButton.tonal(
                    onPressed: controller.buyStreakFreeze,
                    child: const Text('Streak freeze (gemmes)'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _DailyGoalEditor(
                current: state.user.dailyXpGoal,
                onSubmit: controller.updateDailyGoal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DailyGoalEditor extends StatelessWidget {
  const _DailyGoalEditor({required this.current, required this.onSubmit});
  final int current;
  final ValueChanged<int> onSubmit;

  @override
  Widget build(BuildContext context) {
    // Options bornées comme le backend (10..200).
    const options = [10, 20, 30, 50, 100, 150, 200];
    return Row(
      children: [
        const Text('Nouvel objectif : '),
        const SizedBox(width: 8),
        DropdownButton<int>(
          value: options.contains(current) ? current : null,
          hint: const Text('choisir'),
          items: [
            for (final o in options)
              DropdownMenuItem(value: o, child: Text('$o XP')),
          ],
          onChanged: (value) {
            if (value != null) onSubmit(value);
          },
        ),
      ],
    );
  }
}
