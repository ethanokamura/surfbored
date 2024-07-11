// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      id: json['id'] as String? ?? '',
      username: json['username'] as String? ?? '',
      imgURL: json['imgURL'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      website: json['website'] as String? ?? '',
      boards: (json['boards'] as List<dynamic>?)
              ?.map((e) => BoardData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => ItemData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      lastOnline: json['lastOnline'] as String? ?? '',
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'imgURL': instance.imgURL,
      'bio': instance.bio,
      'website': instance.website,
      'boards': instance.boards,
      'items': instance.items,
      'lastOnline': instance.lastOnline,
    };

BoardData _$BoardDataFromJson(Map<String, dynamic> json) => BoardData(
      id: json['id'] as String? ?? '',
      uid: json['uid'] as String? ?? '',
      imgURL: json['imgURL'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => ItemData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$BoardDataToJson(BoardData instance) => <String, dynamic>{
      'id': instance.id,
      'imgURL': instance.imgURL,
      'title': instance.title,
      'description': instance.description,
      'uid': instance.uid,
      'likes': instance.likes,
      'items': instance.items,
    };

ItemData _$ItemDataFromJson(Map<String, dynamic> json) => ItemData(
      id: json['id'] as String? ?? '',
      imgURL: json['imgURL'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      uid: json['uid'] as String? ?? '',
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$ItemDataToJson(ItemData instance) => <String, dynamic>{
      'id': instance.id,
      'imgURL': instance.imgURL,
      'title': instance.title,
      'description': instance.description,
      'uid': instance.uid,
      'tags': instance.tags,
      'likes': instance.likes,
    };
