// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tag _$TagFromJson(Map<String, dynamic> json) => Tag(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      users:
          (json['users'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      posts:
          (json['posts'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      boards: (json['boards'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      usageCount: (json['usageCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TagToJson(Tag instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'users': instance.users,
      'posts': instance.posts,
      'boards': instance.boards,
      'usageCount': instance.usageCount,
    };
