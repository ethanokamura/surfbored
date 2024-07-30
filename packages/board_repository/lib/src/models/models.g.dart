// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Board _$BoardFromJson(Map<String, dynamic> json) => Board(
      uid: json['uid'] as String,
      title: json['title'] as String,
      id: json['id'] as String? ?? '',
      photoURL: json['photoURL'] as String?,
      description: json['description'] as String? ?? '',
      saves: (json['saves'] as num?)?.toInt() ?? 0,
      posts:
          (json['posts'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      createdAt: timestamp.fromJson(json['createdAt']),
    );

Map<String, dynamic> _$BoardToJson(Board instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'uid': instance.uid,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('photoURL', instance.photoURL);
  val['title'] = instance.title;
  val['description'] = instance.description;
  val['saves'] = instance.saves;
  val['posts'] = instance.posts;
  val['tags'] = instance.tags;
  writeNotNull('createdAt', timestamp.toJson(instance.createdAt));
  return val;
}
