import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:appiray/core/network/api_exception.dart';
import 'package:appiray/core/providers/core_providers.dart';
import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/content/data/content_remote_datasource.dart';
import 'package:appiray/features/content/data/models/content_models.dart';
import 'package:appiray/features/content/domain/content_entities.dart';
import 'package:appiray/features/content/domain/content_repository.dart';

part 'content_repository_impl.g.dart';

@riverpod
ContentRemoteDataSource contentRemoteDataSource(
        ContentRemoteDataSourceRef ref) =>
    ContentRemoteDataSource(ref.watch(dioClientProvider));

@riverpod
ContentRepository contentRepository(ContentRepositoryRef ref) =>
    ContentRepositoryImpl(ref.watch(contentRemoteDataSourceProvider));

class ContentRepositoryImpl implements ContentRepository {
  ContentRepositoryImpl(this._remote);
  final ContentRemoteDataSource _remote;

  Publication _pub(PublicationDto d) => Publication(
        id: d.id,
        title: d.title,
        body: d.body,
        category: d.category,
        author: d.author,
        likesCount: d.likesCount,
        commentsCount: d.commentsCount,
        coverImageUrl: d.coverImageUrl,
        publishedAt: d.publishedAt,
      );

  PublicationComment _comment(CommentDto d) => PublicationComment(
        id: d.id,
        publicationId: d.publicationId,
        userId: d.userId,
        body: d.body,
        createdAt: d.createdAt,
      );

  @override
  Future<Result<List<Publication>>> listPublications({
    int page = 1,
    String? category,
  }) =>
      _guard(() async {
        final paginated =
            await _remote.listPublications(page: page, category: category);
        return paginated.items.map(_pub).toList();
      });

  @override
  Future<Result<Publication>> getPublication(String id) =>
      _guard(() async => _pub(await _remote.getPublication(id)));

  @override
  Future<Result<void>> like(String id) => _guard(() => _remote.like(id));

  @override
  Future<Result<void>> unlike(String id) => _guard(() => _remote.unlike(id));

  @override
  Future<Result<List<PublicationComment>>> listComments(String publicationId) =>
      _guard(() async {
        final list = await _remote.listComments(publicationId);
        return list.map(_comment).toList();
      });

  @override
  Future<Result<PublicationComment>> addComment(
    String publicationId,
    String body,
  ) =>
      _guard(() async =>
          _comment(await _remote.addComment(publicationId, body)));

  Future<Result<T>> _guard<T>(Future<T> Function() body) async {
    try {
      return Result.success(await body());
    } on ApiException catch (e) {
      return Result.failure(Failure.fromApiException(e));
    } catch (e) {
      return Result.failure(Failure.unexpected(e));
    }
  }
}
