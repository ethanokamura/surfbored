import 'package:api_client/api_client.dart' as firebase show User;
import 'package:api_client/api_client.dart';
import 'package:app_core/app_core.dart';
part 'models.g.dart';

@JsonSerializable()
class User extends Equatable {
  // User data constructor
  const User({
    required this.uid,
    this.photoURL,
    this.username = '',
    this.name = '',
    this.bio = '',
    this.friends = 0,
    this.posts = const [],
    this.boards = const [],
    this.tags = const [],
    this.lastSignInAt,
    this.memberSince,
  });

  // factory constructor
  // this tells the json serializable what to do
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  factory User.fromFirebaseUser(firebase.User firebaseUser) => User(
        uid: firebaseUser.uid,
        photoURL: firebaseUser.photoURL ?? '',
        lastSignInAt: DateTime.now(),
      );

  // allows for an easy way to stream data
  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return User(
      uid: data['uid'] as String? ?? '',
      photoURL: data['photoURL'] as String? ?? '',
      username: data['username'] as String? ?? '',
      name: data['name'] as String? ?? '',
      bio: data['bio'] as String? ?? '',
      friends: data['friends'] as int? ?? 0,
      posts: (data['posts'] as List<dynamic>)
          .map((post) => post as String)
          .toList(),
      boards: (data['boards'] as List<dynamic>)
          .map((board) => board as String)
          .toList(),
      tags:
          (data['tags'] as List<dynamic>).map((tag) => tag as String).toList(),
      lastSignInAt:
          (data['lastSignInAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      memberSince:
          (data['memberSince'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // data fields
  final String uid;
  final String username;
  final String name;
  final String? photoURL;
  final String bio;
  final int friends;
  final List<String> posts;
  final List<String> boards;
  final List<String> tags;
  @timestamp
  final DateTime? memberSince;
  @timestamp
  final DateTime? lastSignInAt;

  static const empty = User(uid: '');

  @override
  List<Object?> get props => [
        uid,
        username,
        name,
        photoURL,
        bio,
        friends,
        posts,
        boards,
        tags,
        lastSignInAt,
        memberSince,
      ];

  // method for converting an instance to JSON
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

extension UserExtensions on User {
  bool get isEmpty => this == User.empty;
  int totalFriends() => friends;
  bool get hasUsername => username != '';
}
