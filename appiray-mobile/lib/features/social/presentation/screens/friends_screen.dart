import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:appiray/core/router/route_paths.dart';
import 'package:appiray/features/social/domain/social_entities.dart';
import 'package:appiray/features/social/presentation/controllers/social_providers.dart';

/// Liste d'amis + demandes en attente. UI minimale.
class FriendsScreen extends ConsumerWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friends = ref.watch(friendsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Amis'),
        actions: [
          IconButton(
            icon: const Icon(Icons.leaderboard),
            tooltip: 'Classement amis',
            onPressed: () => context.push(RoutePaths.friendsLeaderboard),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Rechercher',
            onPressed: () => context.push(RoutePaths.userSearch),
          ),
        ],
      ),
      body: SafeArea(
        child: friends.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (list) => list.isEmpty
              ? const Center(child: Text('Pas encore d\'amis.'))
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final f = list[i];
                    final pending = f.status == FriendshipStatus.pending;
                    return ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(f.friendId),
                      subtitle: Text(pending ? 'En attente' : 'Ami'),
                      trailing: pending
                          ? TextButton(
                              onPressed: () => ref
                                  .read(friendsControllerProvider.notifier)
                                  .accept(f.id),
                              child: const Text('Accepter'),
                            )
                          : null,
                    );
                  },
                ),
        ),
      ),
    );
  }
}
