import 'package:api_client/api_client.dart';
import 'package:app_core/app_core.dart';
part 'models.g.dart';

@JsonSerializable()
class Board extends Equatable {
  // constructor
  const Board({
    required this.uid,
    required this.title,
    this.id = '',
    this.photoURL,
    this.description = '',
    this.saves = 0,
    this.posts = const [],
    this.tags = const [],
    this.createdAt,
  });

  // factory constructor
  // this tells the json serializable what to do
  factory Board.fromJson(Map<String, dynamic> json) => _$BoardFromJson(json);

  // allows for an easy way to stream data
  factory Board.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return Board(
      id: doc.id,
      uid: data['uid'] as String? ?? '',
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      photoURL: data['photoURL'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      saves: data['saves'] as int? ?? 0,
      posts: (data['posts'] as List<dynamic>)
          .map((post) => post as String)
          .toList(),
      tags:
          (data['tags'] as List<dynamic>).map((tag) => tag as String).toList(),
    );
  }

  // allows for easy way to access algolia data
  factory Board.fromAlgolia(Map<String, dynamic> json) {
    return Board(
      id: json['objectID'] as String? ?? '',
      uid: json['uid'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      photoURL: json['photoURL'] as String? ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      saves: json['saves'] as int? ?? 0,
      posts: (json['posts'] as List<dynamic>)
          .map((post) => post as String)
          .toList(),
      tags:
          (json['tags'] as List<dynamic>).map((tag) => tag as String).toList(),
    );
  }

  // data fields
  final String id;
  final String uid;
  final String? photoURL;
  final String title;
  final String description;
  final int saves;
  final List<String> posts;
  final List<String> tags;
  @timestamp
  final DateTime? createdAt;

  static const empty = Board(
    uid: '',
    title: '',
  );

  @override
  List<Object?> get props => [
        id,
        title,
        photoURL,
        uid,
        description,
        saves,
        posts,
        tags,
        createdAt,
      ];

  // method for converting an instance to JSON
  Map<String, dynamic> toJson() => _$BoardToJson(this);
}

extension BoardExtensions on Board {
  bool get isEmpty => this == Board.empty;
  int totalSaves() => saves;
  bool hasPost({required String postID}) => posts.contains(postID);
  bool userOwnsBoard({required String userID}) => uid == userID;
}
