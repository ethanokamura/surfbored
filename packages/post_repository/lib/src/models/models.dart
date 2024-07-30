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

  // allows for an easy way to stream data
  factory Post.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return Post(
      id: doc.id,
      uid: data['uid'] as String? ?? '',
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      photoURL: data['photoURL'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      likes: data['likes'] as int? ?? 0,
      tags:
          (data['tags'] as List<dynamic>).map((tag) => tag as String).toList(),
    );
  }

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
