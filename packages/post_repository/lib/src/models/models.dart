import 'package:api_client/api_client.dart';
import 'package:app_core/app_core.dart';
part 'models.g.dart';

@JsonSerializable()
class Post extends Equatable {
  // constructor
  const Post({
    required this.uid,
    required this.title,
    this.id = '',
    this.likes = 0,
    this.tags = const [],
    this.photoURL = '',
    this.description = '',
    this.createdAt,
  });

  // factory constructor for creating an instance from JSON
  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);

  // data fields
  final String id;
  final String? photoURL;
  final String uid;
  final String title;
  final String description;
  final int likes;
  final List<String> tags;
  @timestamp
  final DateTime? createdAt;

  static const empty = Post(
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
        likes,
        tags,
        createdAt,
      ];

  // method for converting an instance to JSON
  Map<String, dynamic> toJson() => _$PostToJson(this);
}

extension PostExtensions on Post {
  bool get isEmpty => this == Post.empty;
  int totalLikes() => likes;
}
