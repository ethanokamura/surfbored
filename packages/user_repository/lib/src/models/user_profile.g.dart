// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      username: json['username'] as String,
      photoUrl: json['photoUrl'] as String?,
    );

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) {
  final val = <String, dynamic>{
    'username': instance.username,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('photoUrl', instance.photoUrl);
  return val;
}
