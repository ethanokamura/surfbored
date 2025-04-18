import 'package:app_core/app_core.dart';

class PostLike extends Equatable {
  const PostLike({
    required this.userId,
    required this.postId,
    this.createdAt,
  });

  factory PostLike.converterSingle(Map<String, dynamic> data) {
    return PostLike.fromJson(data);
  }

  factory PostLike.fromJson(Map<String, dynamic> json) {
    return PostLike(
      userId: json[userIdConverter]?.toString() ?? '',
      postId: json[postIdConverter] as int,
      createdAt: json[createdAtConverter] != null
          ? DateTime.tryParse(json[createdAtConverter].toString())?.toUtc()
          : DateTime.now().toUtc(),
    );
  }

  static String get userIdConverter => 'user_id';
  static String get postIdConverter => 'post_id';
  static String get createdAtConverter => 'created_at';

  static const empty = PostLike(userId: '', postId: 0);

  final String userId;
  final int postId;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [
        userId,
        postId,
        createdAt,
      ];

  static List<PostLike> converter(List<Map<String, dynamic>> data) {
    return data.map(PostLike.fromJson).toList();
  }

  // method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return _generateMap(
      userId: userId,
      postId: postId,
      createdAt: createdAt,
    );
  }

  static Map<String, dynamic> _generateMap({
    String? userId,
    int? postId,
    DateTime? createdAt,
  }) {
    return {
      if (userId != null) userIdConverter: userId,
      if (postId != null) postIdConverter: postId,
      if (createdAt != null) createdAtConverter: createdAt.toUtc().toString(),
    };
  }

  static Map<String, dynamic> insert({
    String? userId,
    int? postId,
    String? title,
    DateTime? createdAt,
  }) {
    return _generateMap(
      userId: userId,
      postId: postId,
      createdAt: createdAt,
    );
  }

  static Map<String, dynamic> update({
    String? userId,
    int? postId,
    String? title,
    DateTime? createdAt,
  }) {
    return _generateMap(
      userId: userId,
      postId: postId,
      createdAt: createdAt,
    );
  }
}

extension PostLikeExtensions on PostLike {
  bool get isEmpty => this == PostLike.empty;
}
