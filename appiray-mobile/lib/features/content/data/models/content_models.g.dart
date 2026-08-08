// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PublicationDtoImpl _$$PublicationDtoImplFromJson(Map<String, dynamic> json) =>
    _$PublicationDtoImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String? ?? '',
      category: json['category'] as String? ?? 'culture',
      status: json['status'] as String? ?? 'published',
      coverImageUrl: json['cover_image_url'] as String?,
      author: json['author'] as String? ?? '',
      publishedAt: json['published_at'] == null
          ? null
          : DateTime.parse(json['published_at'] as String),
      likesCount: (json['likes_count'] as num?)?.toInt() ?? 0,
      commentsCount: (json['comments_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$PublicationDtoImplToJson(
  _$PublicationDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'body': instance.body,
  'category': instance.category,
  'status': instance.status,
  'cover_image_url': instance.coverImageUrl,
  'author': instance.author,
  'published_at': instance.publishedAt?.toIso8601String(),
  'likes_count': instance.likesCount,
  'comments_count': instance.commentsCount,
};

_$CommentDtoImpl _$$CommentDtoImplFromJson(Map<String, dynamic> json) =>
    _$CommentDtoImpl(
      id: json['id'] as String,
      publicationId: json['publication_id'] as String,
      userId: json['user_id'] as String,
      body: json['body'] as String? ?? '',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$CommentDtoImplToJson(_$CommentDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'publication_id': instance.publicationId,
      'user_id': instance.userId,
      'body': instance.body,
      'created_at': instance.createdAt?.toIso8601String(),
    };

_$PaginatedPublicationsDtoImpl _$$PaginatedPublicationsDtoImplFromJson(
  Map<String, dynamic> json,
) => _$PaginatedPublicationsDtoImpl(
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => PublicationDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <PublicationDto>[],
  total: (json['total'] as num?)?.toInt() ?? 0,
  page: (json['page'] as num?)?.toInt() ?? 1,
  pageSize: (json['page_size'] as num?)?.toInt() ?? 20,
);

Map<String, dynamic> _$$PaginatedPublicationsDtoImplToJson(
  _$PaginatedPublicationsDtoImpl instance,
) => <String, dynamic>{
  'items': instance.items,
  'total': instance.total,
  'page': instance.page,
  'page_size': instance.pageSize,
};
