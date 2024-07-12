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
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => ItemData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      boards: (json['boards'] as List<dynamic>?)
              ?.map((e) => BoardData.fromJson(e as Map<String, dynamic>))
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
      lastOnline: json['lastOnline'] as String? ?? '',
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'imgURL': instance.imgURL,
      'bio': instance.bio,
      'website': instance.website,
      'items': instance.items,
      'boards': instance.boards,
      'likedItems': instance.likedItems,
      'likedBoards': instance.likedBoards,
      'lastOnline': instance.lastOnline,
    };

BoardData _$BoardDataFromJson(Map<String, dynamic> json) => BoardData(
      id: json['id'] as String? ?? '',
      uid: json['uid'] as String? ?? '',
      imgURL: json['imgURL'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      likedBy: (json['likedBy'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
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
      'likedBy': instance.likedBy,
      'items': instance.items,
    };

ItemData _$ItemDataFromJson(Map<String, dynamic> json) => ItemData(
      id: json['id'] as String? ?? '',
      imgURL: json['imgURL'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      uid: json['uid'] as String? ?? '',
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      likedBy: (json['likedBy'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
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
      'likes': instance.likes,
      'likedBy': instance.likedBy,
      'tags': instance.tags,
    };
