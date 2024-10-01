// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Board _$BoardFromJson(Map<String, dynamic> json) => Board(
      creatorId: (json['creatorId'] as num).toInt(),
      title: json['title'] as String,
      id: (json['id'] as num?)?.toInt() ?? 0,
      description: json['description'] as String? ?? '',
      photoUrl: json['photoUrl'] as String?,
      isPublic: json['isPublic'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$BoardToJson(Board instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'creatorId': instance.creatorId,
    'title': instance.title,
    'description': instance.description,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('photoUrl', instance.photoUrl);
  val['isPublic'] = instance.isPublic;
  writeNotNull('createdAt', instance.createdAt?.toIso8601String());
  return val;
}
