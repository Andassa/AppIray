// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationDtoImpl _$$NotificationDtoImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationDtoImpl(
  id: json['id'] as String,
  type: json['type'] as String? ?? 'system',
  payload:
      json['payload'] as Map<String, dynamic>? ?? const <String, dynamic>{},
  readAt: json['read_at'] == null
      ? null
      : DateTime.parse(json['read_at'] as String),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$$NotificationDtoImplToJson(
  _$NotificationDtoImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'type': instance.type,
  'payload': instance.payload,
  'read_at': instance.readAt?.toIso8601String(),
  'created_at': instance.createdAt?.toIso8601String(),
};
