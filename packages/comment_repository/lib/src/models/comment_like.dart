import 'package:app_core/app_core.dart';

class CommentLike extends Equatable {
  const CommentLike({
    required this.userId,
    required this.commentId,
    this.createdAt,
  });

  factory CommentLike.converterSingle(Map<String, dynamic> data) {
    return CommentLike.fromJson(data);
  }

  factory CommentLike.fromJson(Map<String, dynamic> json) {
    return CommentLike(
      userId: json[userIdConverter]?.toString() ?? '',
      commentId: json[commentIdConverter] as int,
      createdAt: json[createdAtConverter] != null
          ? DateTime.tryParse(json[createdAtConverter].toString())
          : DateTime.now().toUtc(),
    );
  }

  static String get userIdConverter => 'user_id';
  static String get commentIdConverter => 'comment_id';
  static String get createdAtConverter => 'created_at';

  static const empty = CommentLike(userId: '', commentId: 0);

  final String userId;
  final int commentId;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [
        userId,
        commentId,
        createdAt,
      ];

  static List<CommentLike> converter(List<Map<String, dynamic>> data) {
    return data.map(CommentLike.fromJson).toList();
  }

  // method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return _generateMap(
      userId: userId,
      commentId: commentId,
      createdAt: createdAt,
    );
  }

  static Map<String, dynamic> _generateMap({
    String? userId,
    int? commentId,
    DateTime? createdAt,
  }) {
    return {
      if (userId != null) userIdConverter: userId,
      if (commentId != null) commentIdConverter: commentId,
      if (createdAt != null) createdAtConverter: createdAt.toUtc().toString(),
    };
  }

  static Map<String, dynamic> insert({
    String? userId,
    int? commentId,
    String? title,
    DateTime? createdAt,
  }) {
    return _generateMap(
      userId: userId,
      commentId: commentId,
      createdAt: createdAt,
    );
  }

  static Map<String, dynamic> update({
    String? userId,
    int? commentId,
    String? title,
    DateTime? createdAt,
  }) {
    return _generateMap(
      userId: userId,
      commentId: commentId,
      createdAt: createdAt,
    );
  }
}

extension CommentLikeExtensions on CommentLike {
  bool get isEmpty => this == CommentLike.empty;
}
