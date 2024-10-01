// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_like.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostLike _$PostLikeFromJson(Map<String, dynamic> json) => PostLike(
      userId: json['userId'] as String,
      postId: json['postId'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PostLikeToJson(PostLike instance) {
  final val = <String, dynamic>{
    'userId': instance.userId,
    'postId': instance.postId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('createdAt', instance.createdAt?.toIso8601String());
  return val;
}
