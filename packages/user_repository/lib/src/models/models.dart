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
    this.followers = const [],
    this.following = const [],
    this.items = const [],
    this.boards = const [],
    this.likedItems = const [],
    this.likedBoards = const [],
    this.likedItemsBoardID = '',
    this.createdAt,
  });

  // factory constructor
  // this tells the json serializable what to do
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  factory User.fromFirebaseUser(firebase.User firebaseUser) => User(
        uid: firebaseUser.uid,
        photoURL: firebaseUser.photoURL ?? '',
        createdAt: DateTime.now(),
      );

  // data fields
  final String uid;
  @JsonKey(defaultValue: '')
  final String username;
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(defaultValue: '')
  final String? photoURL;
  @JsonKey(defaultValue: '')
  final String bio;
  @JsonKey(defaultValue: '')
  final String website;
  final List<String> followers;
  final List<String> following;
  final List<String> items;
  final List<String> boards;
  final List<String> likedItems;
  final List<String> likedBoards;
  @JsonKey(defaultValue: '')
  final String likedItemsBoardID;
  @timestamp
  final DateTime? createdAt;

  static const empty = User(uid: '');

  @override
  List<Object?> get props => [
        uid,
        username,
        name,
        photoURL,
        bio,
        website,
        followers,
        following,
        items,
        boards,
        likedItems,
        likedBoards,
        likedItemsBoardID,
        createdAt,
      ];

  // method for converting an instance to JSON
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

extension UserExtensions on User {
  bool get isEmpty => this == User.empty;
  int totalFollowers() => followers.length;
  int totalFollowing() => following.length;
  bool get hasUsername => username != '';

  bool hasLikedItem({required String itemID}) => likedItems.contains(itemID);
  bool hasLikedBoard({required String boardID}) =>
      likedBoards.contains(boardID);
  bool isFollowingUser({required String userID}) => following.contains(userID);
  bool isFollowedByUser({required String userID}) => followers.contains(userID);
}
