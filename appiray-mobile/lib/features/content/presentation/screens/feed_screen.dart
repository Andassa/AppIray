import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:appiray/core/router/route_paths.dart';
import 'package:appiray/features/content/presentation/controllers/content_providers.dart';

/// Fil des publications (histoire / géo / culture). UI minimale.
class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feed = ref.watch(feedProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Découvrir Madagascar')),
      body: SafeArea(
        child: feed.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (list) => list.isEmpty
              ? const Center(child: Text('Aucune publication.'))
              : RefreshIndicator(
                  onRefresh: () => ref.refresh(feedProvider.future),
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      final p = list[i];
                      return ListTile(
                        title: Text(p.title),
                        subtitle: Text('${p.category} · ${p.author}'),
                        trailing: Text('♥ ${p.likesCount}'),
                        onTap: () => context
                            .push(RoutePaths.publicationDetailFor(p.id)),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
