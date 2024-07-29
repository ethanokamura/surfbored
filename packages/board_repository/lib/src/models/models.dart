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
    this.savedBy = const [],
    this.posts = const [],
    this.createdAt,
  });

  // factory constructor
  // this tells the json serializable what to do
  factory Board.fromJson(Map<String, dynamic> json) => _$BoardFromJson(json);

  // data fields
  final String id;
  final String uid;
  final String? photoURL;
  final String title;
  final String description;
  final int saves;
  final List<String> savedBy;
  final List<String> posts;
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
        savedBy,
        posts,
        createdAt,
      ];

  // method for converting an instance to JSON
  Map<String, dynamic> toJson() => _$BoardToJson(this);
}

extension BoardExtensions on Board {
  bool get isEmpty => this == Board.empty;
  int totalSaves() => saves;
  bool hasPost({required String postID}) => posts.contains(postID);
}
