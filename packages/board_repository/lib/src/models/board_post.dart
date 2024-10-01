import 'package:app_core/app_core.dart';
part 'board_post.g.dart';

@JsonSerializable()
class BoardPost extends Equatable {
  const BoardPost({
    required this.postId,
    required this.boardId,
    this.createdAt,
  });

  factory BoardPost.converterSingle(Map<String, dynamic> data) {
    return BoardPost.fromJson(data);
  }

  factory BoardPost.fromJson(Map<String, dynamic> json) {
    return BoardPost(
      postId: json[postIdConverter]?.toString() ?? '',
      boardId: json[boardIdConverter]?.toString() ?? '',
      createdAt: json[createdAtConverter] != null
          ? DateTime.tryParse(json[createdAtConverter].toString())
          : DateTime.now().toUtc(),
    );
  }

  static String get postIdConverter => 'post_id';
  static String get boardIdConverter => 'board_id';
  static String get createdAtConverter => 'created_at';

  static const empty = BoardPost(postId: '', boardId: '');

  final String postId;
  final String boardId;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [
        postId,
        boardId,
        createdAt,
      ];

  static List<BoardPost> converter(List<Map<String, dynamic>> data) {
    return data.map(BoardPost.fromJson).toList();
  }

  // method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return _generateMap(
      postId: postId,
      boardId: boardId,
      createdAt: createdAt,
    );
  }

  static Map<String, dynamic> _generateMap({
    String? postId,
    String? boardId,
    DateTime? createdAt,
  }) {
    return {
      if (postId != null) postIdConverter: postId,
      if (boardId != null) boardIdConverter: boardId,
      if (createdAt != null) createdAtConverter: createdAt.toUtc().toString(),
    };
  }

  static Map<String, dynamic> insert({
    String? postId,
    String? boardId,
    String? title,
    DateTime? createdAt,
  }) {
    return _generateMap(
      postId: postId,
      boardId: boardId,
      createdAt: createdAt,
    );
  }

  static Map<String, dynamic> update({
    String? postId,
    String? boardId,
    String? title,
    DateTime? createdAt,
  }) {
    return _generateMap(
      postId: postId,
      boardId: boardId,
      createdAt: createdAt,
    );
  }
}

extension BoardPostExtensions on BoardPost {
  bool get isEmpty => this == BoardPost.empty;
}
