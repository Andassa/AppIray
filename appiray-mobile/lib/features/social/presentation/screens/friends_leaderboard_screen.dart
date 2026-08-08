import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appiray/features/social/presentation/controllers/social_providers.dart';

/// Classement entre amis. UI minimale.
class FriendsLeaderboardScreen extends ConsumerWidget {
  const FriendsLeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final board = ref.watch(friendsLeaderboardProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Classement amis')),
      body: SafeArea(
        child: board.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (list) => list.isEmpty
              ? const Center(child: Text('Classement vide.'))
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final e = list[i];
                    return ListTile(
                      leading: Text('${e.rank}'),
                      title: Text(e.username),
                      trailing: Text('${e.xpTotal} XP'),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
