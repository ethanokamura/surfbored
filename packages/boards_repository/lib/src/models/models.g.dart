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
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      likedBy: (json['likedBy'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      items:
          (json['items'] as List<dynamic>?)?.map((e) => e as String).toList() ??
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
  val['likes'] = instance.likes;
  val['likedBy'] = instance.likedBy;
  val['items'] = instance.items;
  writeNotNull('createdAt', timestamp.toJson(instance.createdAt));
  return val;
}
