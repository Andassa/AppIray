import 'package:freezed_annotation/freezed_annotation.dart';

part 'content_models.freezed.dart';
part 'content_models.g.dart';

@freezed
class PublicationDto with _$PublicationDto {
  const factory PublicationDto({
    required String id,
    required String title,
    @Default('') String body,
    @Default('culture') String category,
    @Default('published') String status,
    @JsonKey(name: 'cover_image_url') String? coverImageUrl,
    @Default('') String author,
    @JsonKey(name: 'published_at') DateTime? publishedAt,
    @JsonKey(name: 'likes_count') @Default(0) int likesCount,
    @JsonKey(name: 'comments_count') @Default(0) int commentsCount,
  }) = _PublicationDto;

  factory PublicationDto.fromJson(Map<String, dynamic> json) =>
      _$PublicationDtoFromJson(json);
}

@freezed
class CommentDto with _$CommentDto {
  const factory CommentDto({
    required String id,
    @JsonKey(name: 'publication_id') required String publicationId,
    @JsonKey(name: 'user_id') required String userId,
    @Default('') String body,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _CommentDto;

  factory CommentDto.fromJson(Map<String, dynamic> json) =>
      _$CommentDtoFromJson(json);
}

@freezed
class PaginatedPublicationsDto with _$PaginatedPublicationsDto {
  const factory PaginatedPublicationsDto({
    @Default(<PublicationDto>[]) List<PublicationDto> items,
    @Default(0) int total,
    @Default(1) int page,
    @JsonKey(name: 'page_size') @Default(20) int pageSize,
  }) = _PaginatedPublicationsDto;

  factory PaginatedPublicationsDto.fromJson(Map<String, dynamic> json) =>
      _$PaginatedPublicationsDtoFromJson(json);
}
