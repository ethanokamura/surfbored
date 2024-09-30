import 'package:app_core/app_core.dart';

part 'models.g.dart';

class UserProfile extends Equatable {
  // UserProfile data constructor
  const UserProfile({
    required this.userId,
    this.username = '',
    this.displayName = '',
    this.photoUrl,
    this.bio = '',
    this.websiteUrl = '',
  });

  factory UserProfile.converterSingle(Map<String, dynamic> data) {
    return UserProfile.fromJson(data);
  }

  // factory constructor
  // this tells the json serializable what to do
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['user_id'] != null ? json['user_id'].toString() : '',
      username: json['username'] != null ? json['username'].toString() : '',
      displayName:
          json['display_name'] != null ? json['display_name'].toString() : '',
      photoUrl: json['photo_url'] != null ? json['photo_url'].toString() : '',
      bio: json['bio'] != null ? json['bio'].toString() : '',
      websiteUrl:
          json['website_url'] != null ? json['website_url'].toString() : '',
    );
  }

  // data fields
  final String userId;
  final String username;
  final String displayName;
  final String? photoUrl;
  final String bio;
  final String websiteUrl;

  static String get userIdConverter => 'user_id';
  static String get usernameConverter => 'username';
  static String get displayNameConverter => 'display_name';
  static String get photoUrlConverter => 'photo_url';
  static String get bioConverter => 'bio';
  static String get websiteUrlConverter => 'website_url';
  static String get lastSignInConverter => 'last_sign_in';
  static String get createdAtConverter => 'created_at';

  static List<UserProfile> converter(List<Map<String, dynamic>> data) {
    return data.map(UserProfile.fromJson).toList();
  }

  static Map<String, dynamic> _generateMap({
    String? userId,
    String? username,
    String? displayName,
    String? photoUrl,
    String? bio,
    String? websiteUrl,
  }) {
    return {
      if (userId != null) 'user_id': userId,
      if (username != null) 'username': username,
      if (displayName != null) 'display_name': displayName,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (bio != null) 'bio': bio,
      if (websiteUrl != null) 'website_url': websiteUrl,
    };
  }

  static Map<String, dynamic> insert({
    String? userId,
    String? username,
    String? displayName,
    String? photoUrl,
    String? bio,
    String? websiteUrl,
  }) {
    return _generateMap(
      userId: userId,
      username: username,
      displayName: displayName,
      photoUrl: photoUrl,
      bio: bio,
      websiteUrl: websiteUrl,
    );
  }

  static Map<String, dynamic> update({
    String? userId,
    String? username,
    String? displayName,
    String? photoUrl,
    String? bio,
    String? websiteUrl,
  }) {
    return _generateMap(
      userId: userId,
      username: username,
      displayName: displayName,
      photoUrl: photoUrl,
      bio: bio,
      websiteUrl: websiteUrl,
    );
  }

  static const empty = UserProfile(userId: '');

  @override
  List<Object?> get props => [
        userId,
        username,
        displayName,
        photoUrl,
        bio,
        websiteUrl,
      ];

  Map<String, dynamic> toJson() {
    return _generateMap(
      userId: userId,
      username: username,
      displayName: displayName,
      photoUrl: photoUrl,
      bio: bio,
      websiteUrl: websiteUrl,
    );
  }
}

extension UserProfileExtensions on UserProfile {
  bool get isEmpty => this == UserProfile.empty;
  bool get hasUsername => username != '';
}
