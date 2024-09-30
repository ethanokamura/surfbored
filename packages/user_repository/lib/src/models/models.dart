import 'package:app_core/app_core.dart';

part 'models.g.dart';

class UserData extends Equatable {
  // UserData data constructor
  const UserData({
    required this.id,
    this.username,
    this.photoUrl,
    this.lastSignIn,
    this.createdAt,
  });

  factory UserData.converterSingle(Map<String, dynamic> data) {
    return UserData.fromJson(data);
  }

  // factory constructor
  // this tells the json serializable what to do
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] != null ? json['id'].toString() : '',
      username: json['username'] != null ? json['username'].toString() : '',
      photoUrl: json['photo_url'] != null ? json['photo_url'].toString() : '',
      lastSignIn: json['last_sign_in'] != null
          ? DateTime.tryParse(json['last_sign_in'].toString())!
          : DateTime.now().toUtc(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())!
          : DateTime.now().toUtc(),
    );
  }

  // data fields
  final String id;
  final String? username;
  final String? photoUrl;
  final DateTime? lastSignIn;
  final DateTime? createdAt;

  static String get idConverter => 'id';
  static String get usernameConverter => 'username';
  static String get photoUrlConverter => 'photo_url';
  static String get lastSignInConverter => 'last_sign_in';
  static String get createdAtConverter => 'created_at';

  static List<UserData> converter(List<Map<String, dynamic>> data) {
    return data.map(UserData.fromJson).toList();
  }

  static Map<String, dynamic> _generateMap({
    String? id,
    String? username,
    String? photoUrl,
    DateTime? lastSignIn,
    DateTime? createdAt,
  }) {
    return {
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (lastSignIn != null) 'last_sign_in': lastSignIn.toUtc().toString(),
      if (createdAt != null) 'created_at': createdAt.toUtc().toString(),
    };
  }

  static Map<String, dynamic> insert({
    String? id,
    String? username,
    String? photoUrl,
    DateTime? lastSignIn,
    DateTime? createdAt,
  }) {
    return _generateMap(
      id: id,
      username: username,
      photoUrl: photoUrl,
      lastSignIn: lastSignIn,
      createdAt: createdAt,
    );
  }

  static Map<String, dynamic> update({
    String? id,
    String? username,
    String? photoUrl,
    DateTime? lastSignIn,
    DateTime? createdAt,
  }) {
    return _generateMap(
      id: id,
      username: username,
      photoUrl: photoUrl,
      lastSignIn: lastSignIn,
      createdAt: createdAt,
    );
  }

  static const empty = UserData(id: '');

  @override
  List<Object?> get props => [
        id,
        username,
        photoUrl,
        createdAt,
        lastSignIn,
      ];

  Map<String, dynamic> toJson() {
    return _generateMap(
      id: id,
      username: username,
      photoUrl: photoUrl,
      lastSignIn: lastSignIn,
      createdAt: createdAt,
    );
  }
}

extension UserExtensions on UserData {
  bool get isEmpty => this == UserData.empty;
  bool get hasUsername => username != '';
}
