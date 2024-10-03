import 'package:app_core/app_core.dart';

class UserData extends Equatable {
  // UserData constructor
  const UserData({
    required this.username,
    required this.uuid,
    this.id,
    this.photoUrl = '',
    this.interests = '',
    this.displayName = '',
    this.bio = '',
    this.websiteUrl = '',
    this.isPublic = true,
    this.isSupporter = false,
    this.lastSignIn,
    this.createdAt,
  });

  factory UserData.converterSingle(Map<String, dynamic> data) {
    return UserData.fromJson(data);
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json[idConverter] as int,
      uuid: json[uuidConverter]?.toString() ?? '',
      username: json[usernameConverter]?.toString() ?? '',
      photoUrl: json[photoUrlConverter]?.toString() ?? '',
      displayName: json[displayNameConverter]?.toString() ?? '',
      bio: json[bioConverter]?.toString() ?? '',
      websiteUrl: json[websiteUrlConverter]?.toString() ?? '',
      interests: json[interestsConverter]?.toString() ?? '',
      isPublic: json[isPublicConverter] as bool? ?? true,
      isSupporter: json[isSupporterConverter] as bool? ?? false,
      lastSignIn: json[lastSignInConverter] != null
          ? DateTime.tryParse(json[lastSignInConverter].toString())?.toUtc()
          : DateTime.now().toUtc(), // Ensuring fallback to UTC
      createdAt: json[createdAtConverter] != null
          ? DateTime.tryParse(json[createdAtConverter].toString())?.toUtc()
          : DateTime.now().toUtc(),
    );
  }

  static String get idConverter => 'id';
  static String get uuidConverter => 'uuid';
  static String get usernameConverter => 'username';
  static String get photoUrlConverter => 'photo_url';
  static String get displayNameConverter => 'display_name';
  static String get bioConverter => 'bio';
  static String get websiteUrlConverter => 'website_url';
  static String get interestsConverter => 'interests';
  static String get isPublicConverter => 'is_public';
  static String get isSupporterConverter => 'is_supporter';
  static String get lastSignInConverter => 'last_sign_in';
  static String get createdAtConverter => 'created_at';

  static const empty = UserData(id: 0, uuid: '', username: '');

  final int? id;
  final String username;
  final String interests;
  final String uuid;
  final String? photoUrl;
  final String displayName;
  final String bio;
  final String websiteUrl;
  final bool isPublic;
  final bool isSupporter;
  final DateTime? lastSignIn;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [
        id,
        uuid,
        username,
        photoUrl,
        displayName,
        bio,
        websiteUrl,
        interests,
        isPublic,
        isSupporter,
        lastSignIn,
        createdAt,
      ];

  static List<UserData> converter(List<Map<String, dynamic>> data) {
    return data.map(UserData.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    return _generateMap(
      id: id,
      uuid: uuid,
      username: username,
      photoUrl: photoUrl,
      displayName: displayName,
      bio: bio,
      websiteUrl: websiteUrl,
      isPublic: isPublic,
      isSupporter: isSupporter,
      lastSignIn: lastSignIn,
      createdAt: createdAt,
    );
  }

  static Map<String, dynamic> _generateMap({
    int? id,
    String? uuid,
    String? username,
    String? photoUrl,
    String? displayName,
    String? bio,
    String? websiteUrl,
    String? interests,
    bool? isPublic,
    bool? isSupporter,
    DateTime? lastSignIn,
    DateTime? createdAt,
  }) {
    return {
      idConverter: id,
      if (uuid != null) uuidConverter: uuid,
      if (username != null) usernameConverter: username,
      if (photoUrl != null) photoUrlConverter: photoUrl,
      if (displayName != null) displayNameConverter: displayName,
      if (bio != null) bioConverter: bio,
      if (websiteUrl != null) websiteUrlConverter: websiteUrl,
      if (interests != null) interestsConverter: interests,
      if (isPublic != null) isPublicConverter: isPublic,
      if (isSupporter != null) isSupporterConverter: isSupporter,
      if (lastSignIn != null)
        lastSignInConverter: lastSignIn.toUtc().toString(),
      if (createdAt != null) createdAtConverter: createdAt.toUtc().toString(),
    };
  }

  static Map<String, dynamic> insert({
    int? id,
    String? uuid,
    String? username,
    String? photoUrl,
    String? displayName,
    String? bio,
    String? websiteUrl,
    String? interests,
    bool isPublic = true,
    bool isSupporter = false,
  }) {
    return _generateMap(
      id: id,
      uuid: uuid,
      username: username,
      photoUrl: photoUrl,
      displayName: displayName,
      bio: bio,
      websiteUrl: websiteUrl,
      interests: interests,
      isPublic: isPublic,
      isSupporter: isSupporter,
      createdAt: DateTime.now().toUtc(), // Automatically set created_at
    );
  }

  static Map<String, dynamic> update({
    int? id,
    String? uuid,
    String? username,
    String? photoUrl,
    String? displayName,
    String? bio,
    String? websiteUrl,
    String? interests,
    bool? isPublic,
    bool? isSupporter,
  }) {
    return _generateMap(
      id: id,
      uuid: uuid,
      username: username,
      photoUrl: photoUrl,
      displayName: displayName,
      bio: bio,
      websiteUrl: websiteUrl,
      interests: interests,
      isPublic: isPublic,
      isSupporter: isSupporter,
      lastSignIn: DateTime.now()
          .toUtc(), // Set lastSignIn to current time during update
    );
  }
}

// Extensions for UserData
extension UserDataExtensions on UserData {
  bool get isEmpty => this == UserData.empty;
  bool get hasUsername => username.isNotEmpty;
}
