// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      postId: (json['postId'] as num).toInt(),
      senderId: (json['senderId'] as num).toInt(),
      message: json['message'] as String,
      id: (json['id'] as num?)?.toInt() ?? 0,
      edited: json['edited'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$CommentToJson(Comment instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'postId': instance.postId,
    'senderId': instance.senderId,
    'message': instance.message,
    'edited': instance.edited,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('createdAt', instance.createdAt?.toIso8601String());
  return val;
}
