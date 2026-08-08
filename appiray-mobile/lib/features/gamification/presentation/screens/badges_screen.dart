import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appiray/features/gamification/presentation/controllers/gamification_providers.dart';

/// Badges de l'utilisateur. UI minimale.
class BadgesScreen extends ConsumerWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badges = ref.watch(myBadgesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Badges')),
      body: SafeArea(
        child: badges.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (list) => list.isEmpty
              ? const Center(child: Text('Aucun badge pour le moment.'))
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final b = list[i];
                    return ListTile(
                      leading: const Icon(Icons.military_tech),
                      title: Text(b.name),
                      subtitle: Text(b.description),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
