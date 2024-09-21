// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      uid: json['uid'] as String,
      photoURL: json['photoURL'] as String?,
      username: json['username'] as String? ?? '',
      name: json['name'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      website: json['website'] as String? ?? '',
      friends: (json['friends'] as num?)?.toInt() ?? 0,
      blockedUsers: (json['blockedUsers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      posts:
          (json['posts'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      boards: (json['boards'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      lastSignInAt: timestamp.fromJson(json['lastSignInAt']),
      memberSince: timestamp.fromJson(json['memberSince']),
    );

Map<String, dynamic> _$UserToJson(User instance) {
  final val = <String, dynamic>{
    'uid': instance.uid,
    'username': instance.username,
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('photoURL', instance.photoURL);
  val['bio'] = instance.bio;
  val['website'] = instance.website;
  val['friends'] = instance.friends;
  val['blockedUsers'] = instance.blockedUsers;
  val['posts'] = instance.posts;
  val['boards'] = instance.boards;
  val['tags'] = instance.tags;
  writeNotNull('memberSince', timestamp.toJson(instance.memberSince));
  writeNotNull('lastSignInAt', timestamp.toJson(instance.lastSignInAt));
  return val;
}
