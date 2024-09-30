// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      id: json['id'] as String,
      creatorId: json['creatorId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      photoUrl: json['photoUrl'] as String?,
      websiteUrl: json['websiteUrl'] as String?,
      isPublic: json['isPublic'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PostToJson(Post instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'creatorId': instance.creatorId,
    'title': instance.title,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('description', instance.description);
  writeNotNull('photoUrl', instance.photoUrl);
  writeNotNull('websiteUrl', instance.websiteUrl);
  writeNotNull('isPublic', instance.isPublic);
  writeNotNull('createdAt', instance.createdAt?.toIso8601String());
  return val;
}
