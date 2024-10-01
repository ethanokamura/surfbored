// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_like.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentLike _$CommentLikeFromJson(Map<String, dynamic> json) => CommentLike(
      userId: (json['userId'] as num).toInt(),
      commentId: (json['commentId'] as num).toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$CommentLikeToJson(CommentLike instance) {
  final val = <String, dynamic>{
    'userId': instance.userId,
    'commentId': instance.commentId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('createdAt', instance.createdAt?.toIso8601String());
  return val;
}
