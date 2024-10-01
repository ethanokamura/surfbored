import 'package:app_core/app_core.dart';
part 'comment.g.dart';

@JsonSerializable()
class Comment extends Equatable {
  // constructor
  const Comment({
    required this.postId,
    required this.senderId,
    required this.message,
    this.id = '',
    this.edited = false,
    this.createdAt,
  });

  factory Comment.converterSingle(Map<String, dynamic> data) {
    return Comment.fromJson(data);
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json[idConverter]?.toString() ?? '',
      postId: json[postIdConverter]?.toString() ?? '',
      senderId: json[senderIdConverter]?.toString() ?? '',
      message: json[messageConverter]?.toString() ?? '',
      edited: json[editedConverter] as bool? ?? false,
      createdAt: json[createdAtConverter] != null
          ? DateTime.tryParse(json[createdAtConverter].toString())
          : DateTime.now().toUtc(),
    );
  }

  static String get idConverter => 'id';
  static String get postIdConverter => 'post_id';
  static String get senderIdConverter => 'sender_id';
  static String get messageConverter => 'message';
  static String get editedConverter => 'edited';
  static String get createdAtConverter => 'created_at';

  // data fields
  final String id;
  final String postId;
  final String senderId;
  final String message;
  final bool edited;
  final DateTime? createdAt;

  static const empty = Comment(
    id: '',
    postId: '',
    senderId: '',
    message: '',
  );

  @override
  List<Object?> get props => [
        id,
        postId,
        senderId,
        message,
        edited,
        createdAt,
      ];

  static List<Comment> converter(List<Map<String, dynamic>> data) {
    return data.map(Comment.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    return _generateMap(
      id: id,
      postId: postId,
      senderId: senderId,
      message: message,
      edited: edited,
      createdAt: createdAt,
    );
  }

  static Map<String, dynamic> _generateMap({
    String? id,
    String? postId,
    String? senderId,
    String? message,
    bool? edited,
    DateTime? createdAt,
  }) {
    return {
      if (id != null) idConverter: id,
      if (postId != null) postIdConverter: postId,
      if (senderId != null) senderIdConverter: senderId,
      if (edited != null) editedConverter: edited,
      if (createdAt != null) createdAtConverter: createdAt.toUtc().toString(),
    };
  }

  static Map<String, dynamic> insert({
    String? id,
    String? postId,
    String? senderId,
    String? message,
    bool? edited,
    DateTime? createdAt,
  }) {
    return _generateMap(
      id: id,
      postId: postId,
      senderId: senderId,
      message: message,
      edited: edited,
      createdAt: createdAt,
    );
  }

  static Map<String, dynamic> update({
    String? id,
    String? postId,
    String? senderId,
    String? message,
    bool? edited,
    DateTime? createdAt,
  }) {
    return _generateMap(
      id: id,
      postId: postId,
      senderId: senderId,
      message: message,
      edited: edited,
      createdAt: createdAt,
    );
  }
}

extension CommentExtensions on Comment {
  bool get isEmpty => this == Comment.empty;
}
