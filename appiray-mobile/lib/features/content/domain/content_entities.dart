// Entités domaine du contenu éditorial.

class Publication {
  const Publication({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.author,
    required this.likesCount,
    required this.commentsCount,
    this.coverImageUrl,
    this.publishedAt,
  });

  final String id;
  final String title;
  final String body;
  final String category;
  final String author;
  final int likesCount;
  final int commentsCount;
  final String? coverImageUrl;
  final DateTime? publishedAt;
}

class PublicationComment {
  const PublicationComment({
    required this.id,
    required this.publicationId,
    required this.userId,
    required this.body,
    this.createdAt,
  });

  final String id;
  final String publicationId;
  final String userId;
  final String body;
  final DateTime? createdAt;
}
