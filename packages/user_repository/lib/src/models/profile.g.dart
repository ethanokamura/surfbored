// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      userId: json['userId'] as String,
      displayName: json['displayName'] as String?,
      bio: json['bio'] as String?,
      websiteUrl: json['websiteUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      isPublic: json['isPublic'] as bool? ?? true,
      isSupporter: json['isSupporter'] as bool? ?? false,
      lastSignIn: json['lastSignIn'] == null
          ? null
          : DateTime.parse(json['lastSignIn'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) {
  final val = <String, dynamic>{
    'userId': instance.userId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('displayName', instance.displayName);
  writeNotNull('bio', instance.bio);
  writeNotNull('websiteUrl', instance.websiteUrl);
  writeNotNull('phoneNumber', instance.phoneNumber);
  val['isPublic'] = instance.isPublic;
  val['isSupporter'] = instance.isSupporter;
  writeNotNull('lastSignIn', instance.lastSignIn?.toIso8601String());
  writeNotNull('createdAt', instance.createdAt?.toIso8601String());
  return val;
}
