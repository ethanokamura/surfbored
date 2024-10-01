// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      username: json['username'] as String,
      id: (json['id'] as num?)?.toInt(),
      photoUrl: json['photoUrl'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      websiteUrl: json['websiteUrl'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      isPublic: json['isPublic'] as bool? ?? true,
      isSupporter: json['isSupporter'] as bool? ?? false,
      lastSignIn: json['lastSignIn'] == null
          ? null
          : DateTime.parse(json['lastSignIn'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['username'] = instance.username;
  writeNotNull('photoUrl', instance.photoUrl);
  val['displayName'] = instance.displayName;
  val['bio'] = instance.bio;
  val['websiteUrl'] = instance.websiteUrl;
  val['phoneNumber'] = instance.phoneNumber;
  val['isPublic'] = instance.isPublic;
  val['isSupporter'] = instance.isSupporter;
  writeNotNull('lastSignIn', instance.lastSignIn?.toIso8601String());
  writeNotNull('createdAt', instance.createdAt?.toIso8601String());
  return val;
}
