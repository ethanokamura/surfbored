// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      uid: json['uid'] as String,
      photoURL: json['photoURL'] as String? ?? '',
      username: json['username'] as String? ?? '',
      name: json['name'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      website: json['website'] as String? ?? '',
      followers: (json['followers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      following: (json['following'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      items:
          (json['items'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      boards: (json['boards'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      likedItems: (json['likedItems'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      likedBoards: (json['likedBoards'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      likedItemsBoardID: json['likedItemsBoardID'] as String? ?? '',
      lastSignInAt: timestamp.fromJson(json['lastSignInAt']),
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
  val['followers'] = instance.followers;
  val['following'] = instance.following;
  val['items'] = instance.items;
  val['boards'] = instance.boards;
  val['likedItems'] = instance.likedItems;
  val['likedBoards'] = instance.likedBoards;
  val['likedItemsBoardID'] = instance.likedItemsBoardID;
  writeNotNull('lastSignInAt', timestamp.toJson(instance.lastSignInAt));
  return val;
}
