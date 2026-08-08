import 'package:appiray/core/utils/result.dart';
import 'package:appiray/features/content/domain/content_entities.dart';

/// Contrat du repository de contenu (domaine).
abstract interface class ContentRepository {
  Future<Result<List<Publication>>> listPublications({
    int page,
    String? category,
  });
  Future<Result<Publication>> getPublication(String id);
  Future<Result<void>> like(String id);
  Future<Result<void>> unlike(String id);
  Future<Result<List<PublicationComment>>> listComments(String publicationId);
  Future<Result<PublicationComment>> addComment(
    String publicationId,
    String body,
  );
}
