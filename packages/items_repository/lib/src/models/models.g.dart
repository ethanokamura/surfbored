// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      uid: json['uid'] as String,
      title: json['title'] as String,
      id: json['id'] as String? ?? '',
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      likedBy: (json['likedBy'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      photoURL: json['photoURL'] as String? ?? '',
      description: json['description'] as String? ?? '',
      createdAt: timestamp.fromJson(json['createdAt']),
    );

Map<String, dynamic> _$ItemToJson(Item instance) {
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
  val['likes'] = instance.likes;
  val['likedBy'] = instance.likedBy;
  val['tags'] = instance.tags;
  writeNotNull('createdAt', timestamp.toJson(instance.createdAt));
  return val;
}
