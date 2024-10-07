import 'package:app_core/app_core.dart';

class Post extends Equatable {
  const Post({
    required this.creatorId,
    required this.title,
    this.id,
    this.description = '',
    this.photoUrl,
    this.link = '',
    this.tags = '',
    this.isPublic = true,
    this.createdAt,
  });

  factory Post.converterSingle(Map<String, dynamic> data) {
    return Post.fromJson(data);
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json[idConverter] as int,
      creatorId: json[creatorIdConverter]?.toString() ?? '',
      title: json[titleConverter]?.toString() ?? '',
      description: json[descriptionConverter]?.toString() ?? '',
      link: json[linkConverter]?.toString() ?? '',
      photoUrl: json[photoUrlConverter]?.toString() ?? '',
      tags: json[tagsConverter]?.toString() ?? '',
      isPublic: json[isPublicConverter] as bool? ?? true,
      createdAt: json[createdAtConverter] != null
          ? DateTime.tryParse(json[createdAtConverter].toString())?.toUtc()
          : DateTime.now().toUtc(),
    );
  }

  static String get idConverter => 'id';
  static String get creatorIdConverter => 'creator_id';
  static String get titleConverter => 'title';
  static String get descriptionConverter => 'description';
  static String get photoUrlConverter => 'photo_url';
  static String get linkConverter => 'link';
  static String get tagsConverter => 'tags';
  static String get isPublicConverter => 'is_public';
  static String get createdAtConverter => 'created_at';
  static String get postSearchQuery => 'title_description_tags';

  static const empty = Post(creatorId: '', title: '');

  final int? id;
  final String creatorId;
  final String title;
  final String description;
  final String? photoUrl;
  final String link;
  final String tags;
  final bool isPublic;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [
        id,
        creatorId,
        title,
        description,
        photoUrl,
        link,
        tags,
        isPublic,
        createdAt,
      ];

  static List<Post> converter(List<Map<String, dynamic>> data) {
    return data.map(Post.fromJson).toList();
  }

  // method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return _generateMap(
      id: id,
      title: title,
      creatorId: creatorId,
      photoUrl: photoUrl,
      description: description,
      link: link,
      tags: tags,
      isPublic: isPublic,
      createdAt: createdAt,
    );
  }

  static Map<String, dynamic> _generateMap({
    int? id,
    String? creatorId,
    String? title,
    String? description,
    String? photoUrl,
    String? link,
    String? tags,
    bool? isPublic,
    DateTime? createdAt,
  }) {
    return {
      if (id != null) idConverter: id,
      if (creatorId != null) creatorIdConverter: creatorId,
      if (title != null) titleConverter: title,
      if (photoUrl != null) photoUrlConverter: photoUrl,
      if (description != null) descriptionConverter: description,
      if (link != null) linkConverter: link,
      if (tags != null) tagsConverter: tags,
      if (isPublic != null) isPublicConverter: isPublic,
      if (createdAt != null) createdAtConverter: createdAt.toUtc().toString(),
    };
  }

  static Map<String, dynamic> insert({
    int? id,
    String? creatorId,
    String? title,
    String? description,
    String? photoUrl,
    String? link,
    String? tags,
    bool? isPublic,
    DateTime? createdAt,
  }) {
    return _generateMap(
      id: id,
      creatorId: creatorId,
      title: title,
      photoUrl: photoUrl,
      description: description,
      link: link,
      tags: tags,
      isPublic: isPublic,
      createdAt: createdAt,
    );
  }

  static Map<String, dynamic> update({
    int? id,
    String? creatorId,
    String? title,
    String? description,
    String? photoUrl,
    String? link,
    String? tags,
    bool? isPublic,
    DateTime? createdAt,
  }) {
    return _generateMap(
      id: id,
      creatorId: creatorId,
      title: title,
      photoUrl: photoUrl,
      description: description,
      link: link,
      tags: tags,
      isPublic: isPublic,
      createdAt: createdAt,
    );
  }
}

extension PostExtensions on Post {
  bool get isEmpty => this == Post.empty;
}
