// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'board_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoardPost _$BoardPostFromJson(Map<String, dynamic> json) => BoardPost(
      postId: json['postId'] as String,
      boardId: json['boardId'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$BoardPostToJson(BoardPost instance) {
  final val = <String, dynamic>{
    'postId': instance.postId,
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
