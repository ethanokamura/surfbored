// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_save.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoardSave _$BoardSaveFromJson(Map<String, dynamic> json) => BoardSave(
      userId: json['userId'] as String,
      boardId: json['boardId'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$BoardSaveToJson(BoardSave instance) {
  final val = <String, dynamic>{
    'userId': instance.userId,
    'boardId': instance.boardId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('createdAt', instance.createdAt?.toIso8601String());
  return val;
}
