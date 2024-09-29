import 'package:app_core/app_core.dart';

part 'models.g.dart';

class UserData extends Equatable {
  // UserData data constructor
  const UserData({
    required this.id,
    this.username = '',
    this.displayName = '',
    this.photoUrl,
    this.bio = '',
    this.websiteUrl = '',
    this.lastSignIn,
    this.createdAt,
  });

  // factory constructor
  // this tells the json serializable what to do
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] != null ? json['id'].toString() : '',
      username: json['username'] != null ? json['username'].toString() : '',
      displayName:
          json['display_name'] != null ? json['display_name'].toString() : '',
      photoUrl: json['photo_url'] != null ? json['photo_url'].toString() : '',
      bio: json['bio'] != null ? json['bio'].toString() : '',
      websiteUrl:
          json['website_url'] != null ? json['website_url'].toString() : '',
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
  final String username;
  final String displayName;
  final String? photoUrl;
  final String bio;
  final String websiteUrl;
  final DateTime? lastSignIn;
  final DateTime? createdAt;

  static String get idConverter => 'id';
  static String get usernameConverter => 'username';
  static String get displayNameConverter => 'display_name';
  static String get photoUrlConverter => 'photo_url';
  static String get bioConverter => 'bio';
  static String get websiteUrlConverter => 'website_url';
  static String get lastSignInConverter => 'last_sign_in';
  static String get createdAtConverter => 'created_at';

  static List<UserData> converter(List<Map<String, dynamic>> data) {
    return data.map(UserData.fromJson).toList();
  }

  static Map<String, dynamic> _generateMap({
    String? id,
    String? username,
    String? displayName,
    String? photoUrl,
    String? bio,
    String? websiteUrl,
    DateTime? lastSignIn,
    DateTime? createdAt,
  }) {
    return {
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (displayName != null) 'display_name': displayName,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (bio != null) 'bio': bio,
      if (websiteUrl != null) 'website_url': websiteUrl,
      if (lastSignIn != null) 'last_sign_in': lastSignIn.toUtc().toString(),
      if (createdAt != null) 'created_at': createdAt.toUtc().toString(),
    };
  }

  static Map<String, dynamic> insert(UserData data) {
    return _generateMap(
      id: data.id,
      username: data.username,
      displayName: data.displayName,
      photoUrl: data.photoUrl,
      bio: data.bio,
      websiteUrl: data.websiteUrl,
      lastSignIn: data.lastSignIn,
      createdAt: data.createdAt,
    );
  }

  static Map<String, dynamic> update(UserData data) {
    return _generateMap(
      id: data.id,
      username: data.username,
      displayName: data.displayName,
      photoUrl: data.photoUrl,
      bio: data.bio,
      websiteUrl: data.websiteUrl,
      lastSignIn: data.lastSignIn,
      createdAt: data.createdAt,
    );
  }

  static const empty = UserData(id: '');

  @override
  List<Object?> get props => [
        id,
        username,
        displayName,
        photoUrl,
        bio,
        websiteUrl,
        createdAt,
        lastSignIn,
      ];

  Map<String, dynamic> toJson() {
    return _generateMap(
      id: id,
      username: username,
      displayName: displayName,
      photoUrl: photoUrl,
      bio: bio,
      websiteUrl: websiteUrl,
      lastSignIn: lastSignIn,
      createdAt: createdAt,
    );
  }
}

extension UserExtensions on UserData {
  bool get isEmpty => this == UserData.empty;
  bool get hasUsername => username != '';
}
