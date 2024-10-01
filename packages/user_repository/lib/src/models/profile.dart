import 'package:app_core/app_core.dart';

part 'profile.g.dart';

@JsonSerializable()
class ProfileData extends Equatable {
  // ProfileData constructor
  const ProfileData({
    required this.userId,
    this.displayName,
    this.bio,
    this.websiteUrl,
    this.phoneNumber,
    this.isPublic = true,
    this.isSupporter = false,
    this.lastSignIn,
    this.createdAt,
  });

  factory ProfileData.converterSingle(Map<String, dynamic> data) {
    return ProfileData.fromJson(data);
  }

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      userId:
          json[userIdConverter] != null ? json[userIdConverter].toString() : '',
      displayName: json[displayNameConverter]?.toString() ?? '',
      bio: json[bioConverter]?.toString() ?? '',
      websiteUrl: json[websiteUrlConverter]?.toString() ?? '',
      phoneNumber: json[phoneNumberConverter]?.toString() ?? '',
      isPublic: json[isPublicConverter] as bool? ?? true,
      isSupporter: json[isSupporterConverter] as bool? ?? false,
      lastSignIn: json[lastSignInConverter] != null
          ? DateTime.tryParse(json[lastSignInConverter].toString())
          : DateTime.now().toUtc(),
      createdAt: json[createdAtConverter] != null
          ? DateTime.tryParse(json[createdAtConverter].toString())
          : DateTime.now().toUtc(),
    );
  }

  static String get userIdConverter => 'user_id';
  static String get displayNameConverter => 'display_name';
  static String get bioConverter => 'bio';
  static String get websiteUrlConverter => 'website_url';
  static String get phoneNumberConverter => 'phone_number';
  static String get isPublicConverter => 'is_public';
  static String get isSupporterConverter => 'is_supporter';
  static String get lastSignInConverter => 'last_sign_in';
  static String get createdAtConverter => 'created_at';

  static const empty = ProfileData(userId: '');

  final String userId;
  final String? displayName;
  final String? bio;
  final String? websiteUrl;
  final String? phoneNumber;
  final bool isPublic;
  final bool isSupporter;
  final DateTime? lastSignIn;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [
        userId,
        displayName,
        bio,
        websiteUrl,
        phoneNumber,
        isPublic,
        isSupporter,
        lastSignIn,
        createdAt,
      ];

  static List<ProfileData> converter(List<Map<String, dynamic>> data) {
    return data.map(ProfileData.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    return _generateMap(
      userId: userId,
      displayName: displayName,
      bio: bio,
      websiteUrl: websiteUrl,
      phoneNumber: phoneNumber,
      isPublic: isPublic,
      isSupporter: isSupporter,
      lastSignIn: lastSignIn,
      createdAt: createdAt,
    );
  }

  static Map<String, dynamic> _generateMap({
    required String userId,
    String? displayName,
    String? bio,
    String? websiteUrl,
    String? phoneNumber,
    bool? isPublic,
    bool? isSupporter,
    DateTime? lastSignIn,
    DateTime? createdAt,
  }) {
    return {
      userIdConverter: userId,
      if (displayName != null) displayNameConverter: displayName,
      if (bio != null) bioConverter: bio,
      if (websiteUrl != null) websiteUrlConverter: websiteUrl,
      if (phoneNumber != null) phoneNumberConverter: phoneNumber,
      if (isPublic != null) isPublicConverter: isPublic,
      if (isSupporter != null) isSupporterConverter: isSupporter,
      if (lastSignIn != null)
        lastSignInConverter: lastSignIn.toUtc().toString(),
      if (createdAt != null) createdAtConverter: createdAt.toUtc().toString(),
    };
  }

  static Map<String, dynamic> insert({
    required String userId,
    String? displayName,
    String? bio,
    String? websiteUrl,
    String? phoneNumber,
    bool isPublic = true,
    bool isSupporter = false,
  }) {
    return _generateMap(
      userId: userId,
      displayName: displayName,
      bio: bio,
      websiteUrl: websiteUrl,
      phoneNumber: phoneNumber,
      isPublic: isPublic,
      isSupporter: isSupporter,
      createdAt: DateTime.now().toUtc(), // Automatically set created_at
    );
  }

  static Map<String, dynamic> update({
    required String userId,
    String? displayName,
    String? bio,
    String? websiteUrl,
    String? phoneNumber,
    bool? isPublic,
    bool? isSupporter,
  }) {
    return _generateMap(
      userId: userId,
      displayName: displayName,
      bio: bio,
      websiteUrl: websiteUrl,
      phoneNumber: phoneNumber,
      isPublic: isPublic,
      isSupporter: isSupporter,
      lastSignIn: DateTime.now()
          .toUtc(), // Set lastSignIn to current time during update
    );
  }
}

// Extensions for ProfileData
extension ProfileDataExtensions on ProfileData {
  bool get isEmpty => this == ProfileData.empty;
}
