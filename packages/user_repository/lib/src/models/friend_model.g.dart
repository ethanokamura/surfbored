// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Friend _$FriendFromJson(Map<String, dynamic> json) => Friend(
      userID1: json['userID1'] as String,
      userID2: json['userID2'] as String,
      createdAt: timestamp.fromJson(json['createdAt']),
    );

Map<String, dynamic> _$FriendToJson(Friend instance) {
  final val = <String, dynamic>{
    'userID1': instance.userID1,
    'userID2': instance.userID2,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('createdAt', timestamp.toJson(instance.createdAt));
  return val;
}
