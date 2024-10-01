// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      creatorId: (json['creatorId'] as num).toInt(),
      title: json['title'] as String,
      id: (json['id'] as num?)?.toInt() ?? 0,
      description: json['description'] as String? ?? '',
      photoUrl: json['photoUrl'] as String?,
      websiteUrl: json['websiteUrl'] as String? ?? '',
      isPublic: json['isPublic'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PostToJson(Post instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['creatorId'] = instance.creatorId;
  val['title'] = instance.title;
  val['description'] = instance.description;
  writeNotNull('photoUrl', instance.photoUrl);
  val['websiteUrl'] = instance.websiteUrl;
  val['isPublic'] = instance.isPublic;
  writeNotNull('createdAt', instance.createdAt?.toIso8601String());
  return val;
}
