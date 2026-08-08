import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appiray/features/gamification/presentation/controllers/gamification_providers.dart';

/// Quêtes quotidiennes. UI minimale.
class QuestsScreen extends ConsumerWidget {
  const QuestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quests = ref.watch(myQuestsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Quêtes du jour')),
      body: SafeArea(
        child: quests.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (list) => list.isEmpty
              ? const Center(child: Text('Aucune quête disponible.'))
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final q = list[i];
                    final target = q.target == 0 ? 1 : q.target;
                    return ListTile(
                      leading: Icon(
                        q.completed
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                      ),
                      title: Text(q.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(q.description),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: (q.progress / target).clamp(0, 1).toDouble(),
                          ),
                        ],
                      ),
                      trailing: Text('+${q.xpReward} XP'),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
