import 'package:app_core/app_core.dart';

class Post extends Equatable {
  const Post({
    required this.creatorId,
    required this.title,
    this.id = 0,
    this.description = '',
    this.photoUrl,
    this.websiteUrl = '',
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
      websiteUrl: json[websiteUrlConverter]?.toString() ?? '',
      photoUrl: json[photoUrlConverter]?.toString() ?? '',
      isPublic: json[isPublicConverter] as bool? ?? true,
      createdAt: json[createdAtConverter] != null
          ? DateTime.tryParse(json[createdAtConverter].toString())
          : DateTime.now().toUtc(),
    );
  }

  static String get idConverter => 'id';
  static String get creatorIdConverter => 'creator_id';
  static String get titleConverter => 'title';
  static String get descriptionConverter => 'description';
  static String get photoUrlConverter => 'photo_url';
  static String get websiteUrlConverter => 'website_url';
  static String get isPublicConverter => 'is_public';
  static String get createdAtConverter => 'created_at';

  static const empty = Post(creatorId: '', title: '');

  final int? id;
  final String creatorId;
  final String title;
  final String description;
  final String? photoUrl;
  final String websiteUrl;
  final bool isPublic;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [
        id,
        creatorId,
        title,
        description,
        photoUrl,
        websiteUrl,
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
      websiteUrl: websiteUrl,
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
    String? websiteUrl,
    bool? isPublic,
    DateTime? createdAt,
  }) {
    return {
      if (id != null) idConverter: id,
      if (creatorId != null) creatorIdConverter: creatorId,
      if (title != null) titleConverter: title,
      if (photoUrl != null) photoUrlConverter: photoUrl,
      if (description != null) descriptionConverter: description,
      if (websiteUrl != null) websiteUrlConverter: websiteUrl,
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
    String? websiteUrl,
    bool? isPublic,
    DateTime? createdAt,
  }) {
    return _generateMap(
      id: id,
      creatorId: creatorId,
      title: title,
      photoUrl: photoUrl,
      description: description,
      websiteUrl: websiteUrl,
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
    String? websiteUrl,
    bool? isPublic,
    DateTime? createdAt,
  }) {
    return _generateMap(
      id: id,
      creatorId: creatorId,
      title: title,
      photoUrl: photoUrl,
      description: description,
      websiteUrl: websiteUrl,
      isPublic: isPublic,
      createdAt: createdAt,
    );
  }
}

extension PostExtensions on Post {
  bool get isEmpty => this == Post.empty;
}
