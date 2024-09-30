import 'package:app_core/app_core.dart';
part 'post.g.dart';

@JsonSerializable()
class Post extends Equatable {
  const Post({
    required this.id,
    required this.creatorId,
    required this.title,
    this.description,
    this.photoUrl,
    this.websiteUrl,
    this.isPublic,
    this.createdAt,
  });

  factory Post.converterSingle(Map<String, dynamic> data) {
    return Post.fromJson(data);
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id']?.toString() ?? '',
      creatorId: json['creator_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      websiteUrl: json['website_url']?.toString() ?? '',
      photoUrl: json['photo_url']?.toString() ?? '',
      isPublic: json['is_public'] as bool? ?? true,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
    );
  }

  static String get idConverter => 'id';
  static String get creatorIdConverter => 'creator_id';
  static String get titleConverter => 'title';
  static String get descriptionConverter => 'description';
  static String get photoUrlConverter => 'photo_url';
  static String get isPublicConverter => 'is_public';
  static String get createdAtConverter => 'created_at';

  static const empty = Post(id: '', creatorId: '', title: '');

  final String id;
  final String creatorId;
  final String title;
  final String? description;
  final String? photoUrl;
  final String? websiteUrl;
  final bool? isPublic;
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
    String? id,
    String? creatorId,
    String? title,
    String? description,
    String? photoUrl,
    String? websiteUrl,
    bool? isPublic,
    DateTime? createdAt,
  }) {
    return {
      if (id != null) 'id': id,
      if (creatorId != null) 'creator_id': creatorId,
      if (title != null) 'title': title,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (description != null) 'description': description,
      if (websiteUrl != null) 'website_url': websiteUrl,
      if (isPublic != null) 'is_public': isPublic,
      if (createdAt != null) 'created_at': createdAt.toUtc().toString(),
    };
  }

  static Map<String, dynamic> insert({
    String? id,
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
    String? id,
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
