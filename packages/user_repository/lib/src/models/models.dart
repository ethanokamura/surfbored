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
    this.website = '',
    this.friends = 0,
    this.blockedUsers = const [],
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
      website: data['website'] as String? ?? '',
      friends: data['friends'] as int? ?? 0,
      blockedUsers: (data['blockedUsers'] as List<dynamic>)
          .map((user) => user as String)
          .toList(),
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

  // allows for easy way to access algolia data
  factory User.fromAlgolia(Map<String, dynamic> json) {
    return User(
      uid: json['objectID'] as String? ?? '',
      photoURL: json['photoURL'] as String? ?? '',
      username: json['username'] as String? ?? '',
      name: json['name'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      website: json['website'] as String? ?? '',
      friends: json['friends'] as int? ?? 0,
      lastSignInAt:
          DateTime.fromMillisecondsSinceEpoch(json['lastSignInAt'] as int),
      posts: (json['posts'] as List<dynamic>)
          .map((post) => post as String)
          .toList(),
      boards: (json['boards'] as List<dynamic>)
          .map((post) => post as String)
          .toList(),
      tags:
          (json['tags'] as List<dynamic>).map((tag) => tag as String).toList(),
    );
  }

  // data fields
  final String uid;
  final String username;
  final String name;
  final String? photoURL;
  final String bio;
  final String website;
  final int friends;
  final List<String> blockedUsers;
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
        website,
        friends,
        blockedUsers,
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
  bool hasUserBlocked(String userID) => blockedUsers.contains(userID);
}
