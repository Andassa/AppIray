import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/content/data/content_repository_impl.dart';
import 'package:appiray/features/content/domain/content_entities.dart';

part 'content_providers.g.dart';

T _unwrap<T>(Result<T> result) => switch (result) {
      Success<T>(:final value) => value,
      FailureResult<T>(:final failure) => throw Exception(failure.message),
    };

/// Fil des publications publiées.
@riverpod
Future<List<Publication>> feed(FeedRef ref) async =>
    _unwrap(await ref.watch(contentRepositoryProvider).listPublications());

/// Détail d'une publication + ses commentaires.
class PublicationDetailState {
  const PublicationDetailState({
    required this.publication,
    required this.comments,
  });
  final Publication publication;
  final List<PublicationComment> comments;
}

@riverpod
class PublicationDetailController extends _$PublicationDetailController {
  @override
  Future<PublicationDetailState> build(String publicationId) =>
      _load(publicationId);

  Future<PublicationDetailState> _load(String publicationId) async {
    final repo = ref.read(contentRepositoryProvider);
    final publication = _unwrap(await repo.getPublication(publicationId));
    final comments = _unwrap(await repo.listComments(publicationId));
    return PublicationDetailState(
      publication: publication,
      comments: comments,
    );
  }

  Future<void> like() async {
    final id = state.valueOrNull?.publication.id;
    if (id == null) return;
    final result = await ref.read(contentRepositoryProvider).like(id);
    if (result.isSuccess) ref.invalidateSelf();
  }

  Future<bool> addComment(String body) async {
    final id = state.valueOrNull?.publication.id;
    if (id == null || body.trim().isEmpty) return false;
    final result =
        await ref.read(contentRepositoryProvider).addComment(id, body);
    if (result.isSuccess) ref.invalidateSelf();
    return result.isSuccess;
  }
}
