// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) => Post(
      uid: json['uid'] as String,
      title: json['title'] as String,
      id: json['id'] as String? ?? '',
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      photoURL: json['photoURL'] as String? ?? '',
      description: json['description'] as String? ?? '',
      website: json['website'] as String? ?? '',
      createdAt: timestamp.fromJson(json['createdAt']),
    );

Map<String, dynamic> _$PostToJson(Post instance) {
  final val = <String, dynamic>{
    'id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('photoURL', instance.photoURL);
  val['uid'] = instance.uid;
  val['title'] = instance.title;
  val['description'] = instance.description;
  val['website'] = instance.website;
  val['likes'] = instance.likes;
  val['tags'] = instance.tags;
  writeNotNull('createdAt', timestamp.toJson(instance.createdAt));
  return val;
}
