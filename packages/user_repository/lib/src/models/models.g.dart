// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      id: json['id'] as String,
      username: json['username'] as String? ?? '',
      name: json['name'] as String? ?? '',
      photoURL: json['photoURL'] as String?,
      bio: json['bio'] as String? ?? '',
      website: json['website'] as String? ?? '',
      friendsCount: (json['friendsCount'] as num?)?.toInt() ?? 0,
      lastSignIn: json['lastSignIn'] == null
          ? null
          : DateTime.parse(json['lastSignIn'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'name': instance.name,
      'photoURL': instance.photoURL,
      'bio': instance.bio,
      'website': instance.website,
      'friendsCount': instance.friendsCount,
      'lastSignIn': instance.lastSignIn?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };
