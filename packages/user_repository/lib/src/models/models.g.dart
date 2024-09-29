// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      id: json['id'] as String,
      username: json['username'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      photoUrl: json['photoUrl'] as String?,
      bio: json['bio'] as String? ?? '',
      websiteUrl: json['websiteUrl'] as String? ?? '',
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
      'displayName': instance.displayName,
      'photoUrl': instance.photoUrl,
      'bio': instance.bio,
      'websiteUrl': instance.websiteUrl,
      'lastSignIn': instance.lastSignIn?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };
