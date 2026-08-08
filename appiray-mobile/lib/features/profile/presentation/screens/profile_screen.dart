import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appiray/features/profile/domain/user_entity.dart';
import 'package:appiray/features/profile/presentation/controllers/profile_controller.dart';

/// Profil : infos user, avatar, logout. UI minimale.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUser = ref.watch(profileControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: SafeArea(
        child: asyncUser.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('$e', textAlign: TextAlign.center),
            ),
          ),
          data: (user) => _ProfileView(user: user),
        ),
      ),
    );
  }
}

class _ProfileView extends ConsumerWidget {
  const _ProfileView({required this.user});
  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        CircleAvatar(
          radius: 36,
          backgroundImage:
              user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
          child: user.avatarUrl == null ? const Icon(Icons.person) : null,
        ),
        const SizedBox(height: 12),
        ListTile(title: const Text('Nom'), subtitle: Text(user.username)),
        ListTile(title: const Text('Email'), subtitle: Text(user.email)),
        ListTile(
          title: const Text('Email vérifié'),
          subtitle: Text(user.isEmailVerified ? 'Oui' : 'Non'),
        ),
        ListTile(title: const Text('Niveau'), subtitle: Text('${user.level}')),
        ListTile(title: const Text('XP total'), subtitle: Text('${user.xpTotal}')),
        const Divider(),
        FilledButton.tonal(
          onPressed: () =>
              ref.read(profileControllerProvider.notifier).logout(),
          child: const Text('Se déconnecter'),
        ),
      ],
    );
  }
}
