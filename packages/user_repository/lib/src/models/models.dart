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
    this.friends = const [],
    this.posts = const [],
    this.boards = const [],
    this.likedPosts = const [],
    this.savedBoards = const [],
    this.likedPostsBoardID = '',
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

  // data fields
  final String uid;
  final String username;
  final String name;
  final String? photoURL;
  final String bio;
  final List<String> friends;
  final List<String> posts;
  final List<String> boards;
  final List<String> likedPosts;
  final List<String> savedBoards;
  final String likedPostsBoardID;
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
        likedPosts,
        savedBoards,
        likedPostsBoardID,
        lastSignInAt,
        memberSince,
      ];

  // method for converting an instance to JSON
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

extension UserExtensions on User {
  bool get isEmpty => this == User.empty;
  int totalFriends() => friends.length;
  bool get hasUsername => username != '';

  bool hasLikedPost({required String postID}) => likedPosts.contains(postID);
  bool hasSavedBoard({required String boardID}) =>
      savedBoards.contains(boardID);
  bool hasFriend({required String userID}) => friends.contains(userID);
}
