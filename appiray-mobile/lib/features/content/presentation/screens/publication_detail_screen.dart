import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appiray/features/content/presentation/controllers/content_providers.dart';

/// Détail d'une publication + commentaires. UI minimale.
class PublicationDetailScreen extends ConsumerStatefulWidget {
  const PublicationDetailScreen({super.key, required this.publicationId});
  final String publicationId;

  @override
  ConsumerState<PublicationDetailScreen> createState() =>
      _PublicationDetailScreenState();
}

class _PublicationDetailScreenState
    extends ConsumerState<PublicationDetailScreen> {
  final _commentCtrl = TextEditingController();

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        publicationDetailControllerProvider(widget.publicationId);
    final asyncState = ref.watch(provider);
    final controller = ref.read(provider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Publication')),
      body: SafeArea(
        child: asyncState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
          data: (state) => Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      state.publication.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text('${state.publication.category} · '
                        '${state.publication.author}'),
                    const SizedBox(height: 12),
                    Text(state.publication.body),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: controller.like,
                          icon: const Icon(Icons.favorite_border),
                          label: Text('${state.publication.likesCount}'),
                        ),
                      ],
                    ),
                    const Divider(),
                    Text(
                      'Commentaires (${state.comments.length})',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    for (final c in state.comments)
                      ListTile(
                        dense: true,
                        title: Text(c.body),
                        subtitle: Text(c.userId),
                      ),
                  ],
                ),
              ),
              _CommentComposer(
                controller: _commentCtrl,
                onSend: () async {
                  final ok =
                      await controller.addComment(_commentCtrl.text);
                  if (ok) _commentCtrl.clear();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommentComposer extends StatelessWidget {
  const _CommentComposer({required this.controller, required this.onSend});
  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration:
                  const InputDecoration(labelText: 'Ajouter un commentaire'),
            ),
          ),
          IconButton(onPressed: onSend, icon: const Icon(Icons.send)),
        ],
      ),
    );
  }
}
