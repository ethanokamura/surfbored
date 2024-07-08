// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      username: json['username'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      website: json['website'] as String? ?? '',
      boards: (json['boards'] as List<dynamic>?)
              ?.map((e) => Board.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      lastOnline: json['lastOnline'] as String? ?? '',
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'username': instance.username,
      'bio': instance.bio,
      'website': instance.website,
      'boards': instance.boards,
      'items': instance.items,
      'lastOnline': instance.lastOnline,
    };

Board _$BoardFromJson(Map<String, dynamic> json) => Board(
      id: json['id'] as String? ?? '',
      uid: json['uid'] as String? ?? '',
      imgID: json['imgID'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$BoardToJson(Board instance) => <String, dynamic>{
      'id': instance.id,
      'imgID': instance.imgID,
      'title': instance.title,
      'description': instance.description,
      'uid': instance.uid,
      'likes': instance.likes,
      'items': instance.items,
    };

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      id: json['id'] as String? ?? '',
      imgID: json['imgID'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      uid: json['uid'] as String? ?? '',
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'id': instance.id,
      'imgID': instance.imgID,
      'title': instance.title,
      'description': instance.description,
      'uid': instance.uid,
      'tags': instance.tags,
      'likes': instance.likes,
    };
