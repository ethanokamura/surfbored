// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      docID: json['docID'] as String,
      senderID: json['senderID'] as String,
      ownerID: json['ownerID'] as String,
      message: json['message'] as String,
      id: json['id'] as String? ?? '',
      edited: json['edited'] as bool? ?? false,
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      replies: (json['replies'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: timestamp.fromJson(json['createdAt']),
    );

Map<String, dynamic> _$CommentToJson(Comment instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'docID': instance.docID,
    'senderID': instance.senderID,
    'ownerID': instance.ownerID,
    'message': instance.message,
    'edited': instance.edited,
    'likes': instance.likes,
    'replies': instance.replies,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('createdAt', timestamp.toJson(instance.createdAt));
  return val;
}
