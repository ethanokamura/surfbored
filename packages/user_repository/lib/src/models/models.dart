import 'package:app_core/app_core.dart';

part 'models.g.dart';

@JsonSerializable()
class UserData extends Equatable {
  // UserData data constructor
  const UserData({
    required this.id,
    this.username = '',
    this.name = '',
    this.photoURL,
    this.bio = '',
    this.website = '',
    this.friendsCount = 0,
    this.lastSignIn,
    this.createdAt,
  });

  // factory constructor
  // this tells the json serializable what to do
  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  // data fields
  final String id;
  final String username;
  final String name;
  final String? photoURL;
  final String bio;
  final String website;
  final int friendsCount;
  final DateTime? lastSignIn;
  final DateTime? createdAt;

  static const empty = UserData(id: '');

  @override
  List<Object?> get props => [
        id,
        username,
        name,
        photoURL,
        bio,
        website,
        friendsCount,
        createdAt,
        lastSignIn,
      ];

  // method for converting an instance to JSON
  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

extension UserExtensions on UserData {
  bool get isEmpty => this == UserData.empty;
  bool get hasUsername => username != '';
}
