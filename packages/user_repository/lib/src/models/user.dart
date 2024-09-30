import 'package:app_core/app_core.dart';

part 'user.g.dart';

@JsonSerializable()
class UserData extends Equatable {
  // UserData constructor
  const UserData({
    required this.id,
    required this.username,
    this.photoUrl,
  });

  factory UserData.converterSingle(Map<String, dynamic> data) {
    return UserData.fromJson(data);
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] != null ? json['id'].toString() : '',
      username: json['username'] != null ? json['username'].toString() : '',
      photoUrl: json['photo_url']?.toString(),
    );
  }

  static String get idConverter => 'id';
  static String get usernameConverter => 'username';
  static String get photoUrlConverter => 'photo_url';

  final String id;
  final String username;
  final String? photoUrl;

  static const empty = UserData(id: '', username: '');

  @override
  List<Object?> get props => [id, username, photoUrl];

  static List<UserData> converter(List<Map<String, dynamic>> data) {
    return data.map(UserData.fromJson).toList();
  }

  static Map<String, dynamic> _generateMap({
    String? id,
    String? username,
    String? photoUrl,
  }) {
    return {
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (photoUrl != null) 'photo_url': photoUrl,
    };
  }

  Map<String, dynamic> toJson() {
    return _generateMap(
      id: id,
      username: username,
      photoUrl: photoUrl,
    );
  }

  static Map<String, dynamic> insert({
    String? id,
    String? username,
    String? photoUrl,
  }) {
    return _generateMap(
      id: id,
      username: username,
      photoUrl: photoUrl,
    );
  }

  static Map<String, dynamic> update({
    String? id,
    String? username,
    String? photoUrl,
  }) {
    return _generateMap(
      id: id,
      username: username,
      photoUrl: photoUrl,
    );
  }
}

// Extensions for UserProfile
extension UserDataExtensions on UserData {
  bool get isEmpty => this == UserData.empty;
  bool get hasUsername => username.isNotEmpty;
}
