import 'package:api_client/api_client.dart';
import 'package:app_core/app_core.dart';
part 'models.g.dart';

@JsonSerializable()
class Comment extends Equatable {
  // constructor
  const Comment({
    required this.docID,
    required this.senderID,
    required this.ownerID,
    required this.message,
    this.id = '',
    this.edited = false,
    this.likes = 0,
    this.likedBy = const [],
    this.createdAt,
  });

  // factory constructor for creating an instance from JSON
  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  // allows for an easy way to stream data
  factory Comment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return Comment(
      id: doc.id,
      docID: data['docID'] as String? ?? '',
      senderID: data['senderID'] as String? ?? '',
      ownerID: data['ownerID'] as String? ?? '',
      message: data['message'] as String? ?? '',
      edited: data['edited'] as bool? ?? false,
      createdAt: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      likes: data['likes'] as int? ?? 0,
      likedBy: (data['likedBy'] as List<dynamic>? ?? [])
          .map((user) => user as String)
          .toList(),
    );
  }

  // data fields
  final String id;
  final String docID;
  final String senderID;
  final String ownerID;
  final String message;
  final List<String> likedBy;
  final bool edited;
  final int likes;
  @timestamp
  final DateTime? createdAt;

  static const empty = Comment(
    docID: '',
    senderID: '',
    ownerID: '',
    message: '',
  );

  @override
  List<Object?> get props => [
        id,
        docID,
        senderID,
        ownerID,
        message,
        edited,
        likes,
        likedBy,
        createdAt,
      ];

  // method for converting an instance to JSON
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}

extension CommentExtensions on Comment {
  bool get isEmpty => this == Comment.empty;
  bool get isEdited => edited;
  int get totalLikes => likes;
  bool likedByUser(String userID) => likedBy.contains(userID);
}
