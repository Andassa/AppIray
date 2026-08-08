import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appiray/features/notifications/presentation/controllers/notifications_controller.dart';

/// Liste des notifications + marquage lu. UI minimale.
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(notificationsControllerProvider);
    final controller = ref.read(notificationsControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Tout marquer lu',
            onPressed: controller.markAllRead,
          ),
        ],
      ),
      body: SafeArea(
        child: asyncState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (list) => list.isEmpty
              ? const Center(child: Text('Aucune notification.'))
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final n = list[i];
                    return ListTile(
                      leading: Icon(
                        n.read
                            ? Icons.notifications_none
                            : Icons.notifications_active,
                      ),
                      title: Text(n.title),
                      subtitle: Text(n.type),
                      onTap: n.read ? null : () => controller.markRead(n.id),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
