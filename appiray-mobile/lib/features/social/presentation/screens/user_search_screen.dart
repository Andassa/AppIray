import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appiray/features/social/domain/social_entities.dart';
import 'package:appiray/features/social/presentation/controllers/social_providers.dart';

/// Recherche d'utilisateurs. UI minimale.
class UserSearchScreen extends ConsumerStatefulWidget {
  const UserSearchScreen({super.key});

  @override
  ConsumerState<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends ConsumerState<UserSearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(userSearchControllerProvider);
    final controller = ref.read(userSearchControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Rechercher')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: "Nom d'utilisateur",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => controller.search(_controller.text),
                  ),
                ),
                onSubmitted: controller.search,
              ),
            ),
            Expanded(
              child: results.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('$e')),
                data: (list) => list.isEmpty
                    ? const Center(child: Text('Aucun résultat.'))
                    : ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, i) =>
                            _ResultTile(result: list[i]),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultTile extends ConsumerWidget {
  const _ResultTile({required this.result});
  final UserSearchResult result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canAdd = result.friendshipStatus == FriendshipStatus.none;
    return ListTile(
      title: Text(result.username),
      subtitle: Text('${result.xpTotal} XP · ${_label(result.friendshipStatus)}'),
      trailing: canAdd
          ? IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () async {
                final ok = await ref
                    .read(userSearchControllerProvider.notifier)
                    .sendRequest(result.userId);
                if (ok && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Demande envoyée')),
                  );
                }
              },
            )
          : null,
    );
  }

  String _label(FriendshipStatus s) => switch (s) {
        FriendshipStatus.accepted => 'Ami',
        FriendshipStatus.pending => 'En attente',
        FriendshipStatus.none => 'Ajouter',
      };
}
