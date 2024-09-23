// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FriendRequest _$FriendRequestFromJson(Map<String, dynamic> json) =>
    FriendRequest(
      senderID: json['senderID'] as String,
      recieverID: json['recieverID'] as String,
      createdAt: timestamp.fromJson(json['createdAt']),
    );

Map<String, dynamic> _$FriendRequestToJson(FriendRequest instance) {
  final val = <String, dynamic>{
    'senderID': instance.senderID,
    'recieverID': instance.recieverID,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('createdAt', timestamp.toJson(instance.createdAt));
  return val;
}
