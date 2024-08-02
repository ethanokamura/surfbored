import 'package:api_client/api_client.dart';
import 'package:app_core/app_core.dart';
part 'models.g.dart';

@JsonSerializable()
class Tag extends Equatable {
  const Tag({
    required this.id,
    required this.name,
    required this.category,
    this.users = const [],
    this.posts = const [],
    this.boards = const [],
    this.usageCount = 0,
  });

  factory Tag.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return Tag(
      id: doc.id,
      name: data['name'] as String,
      category: data['category'] as String,
      users: (data['users'] as List<dynamic>)
          .map((user) => user as String)
          .toList(),
      posts: (data['posts'] as List<dynamic>)
          .map((post) => post as String)
          .toList(),
      boards: (data['boards'] as List<dynamic>)
          .map((board) => board as String)
          .toList(),
      usageCount: data['usageCount'] as int? ?? 0,
    );
  }
  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  final String id;
  final String name;
  final String category;
  final List<String> users;
  final List<String> posts;
  final List<String> boards;
  final int usageCount;

  static const empty = Tag(
    id: '',
    name: '',
    category: '',
  );

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        users,
        posts,
        boards,
        usageCount,
      ];

  // method for converting an instance to JSON
  Map<String, dynamic> toJson() => _$TagToJson(this);
}

extension TagExtensions on Tag {
  bool get isEmpty => this == Tag.empty;
  int totalSaves() => usageCount;
  String getCategory() => category;
  bool hasUser({required String userID}) => users.contains(userID);
  bool hasPost({required String postID}) => posts.contains(postID);
  bool hasBoard({required String boardID}) => boards.contains(boardID);
}
