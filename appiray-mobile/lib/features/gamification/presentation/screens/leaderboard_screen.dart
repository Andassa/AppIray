import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:appiray/core/router/route_paths.dart';
import 'package:appiray/features/gamification/presentation/controllers/gamification_providers.dart';

/// Ligue courante + classement. UI minimale.
class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final league = ref.watch(myLeagueProvider);
    final board = ref.watch(leaderboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ligue'),
        actions: [
          IconButton(
            icon: const Icon(Icons.military_tech),
            tooltip: 'Badges',
            onPressed: () => context.push(RoutePaths.badges),
          ),
          IconButton(
            icon: const Icon(Icons.checklist),
            tooltip: 'Quêtes',
            onPressed: () => context.push(RoutePaths.quests),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            league.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(12),
                child: Text('Ligue indisponible: $e'),
              ),
              data: (l) => ListTile(
                title: Text('Ligue ${l.name}'),
                subtitle: Text('Palier ${l.tier}'),
              ),
            ),
            const Divider(),
            Expanded(
              child: board.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('$e')),
                data: (entries) => entries.isEmpty
                    ? const Center(child: Text('Classement vide.'))
                    : ListView.builder(
                        itemCount: entries.length,
                        itemBuilder: (context, i) {
                          final e = entries[i];
                          return ListTile(
                            leading: Text('${e.rank}'),
                            title: Text(e.username),
                            trailing: Text('${e.xp} XP'),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
