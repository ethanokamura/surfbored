import 'package:app_core/app_core.dart';

part 'profile.g.dart';

@JsonSerializable()
class UserProfile extends Equatable {
  // UserProfile constructor
  const UserProfile({
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

  factory UserProfile.converterSingle(Map<String, dynamic> data) {
    return UserProfile.fromJson(data);
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['user_id'] != null ? json['user_id'].toString() : '',
      displayName: json['display_name']?.toString(),
      bio: json['bio']?.toString() ?? '',
      websiteUrl: json['website_url']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
      isPublic: json['is_public'] as bool? ?? true,
      isSupporter: json['is_supporter'] as bool? ?? false,
      lastSignIn: json['last_sign_in'] != null
          ? DateTime.tryParse(json['last_sign_in'].toString())
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : DateTime.now().toUtc(),
    );
  }

  static String get userIdConverter => 'id';
  static String get displayNameConverter => 'display_name';
  static String get bioConverter => 'bio';
  static String get websiteUrlConverter => 'website_url';
  static String get phoneNumberConverter => 'phone_number';
  static String get isPublicConverter => 'is_public';
  static String get isSupporterConverter => 'is_supporter';
  static String get lastSignInConverter => 'last_sign_in';
  static String get createdAtConverter => 'created_at';

  static const empty = UserProfile(userId: '');

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

  static List<UserProfile> converter(List<Map<String, dynamic>> data) {
    return data.map(UserProfile.fromJson).toList();
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
      'user_id': userId,
      if (displayName != null) 'display_name': displayName,
      if (bio != null) 'bio': bio,
      if (websiteUrl != null) 'website_url': websiteUrl,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (isPublic != null) 'is_public': isPublic,
      if (isSupporter != null) 'is_supporter': isSupporter,
      if (lastSignIn != null)
        'last_sign_in': lastSignIn.toUtc().toIso8601String(),
      if (createdAt != null) 'created_at': createdAt.toUtc().toIso8601String(),
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

// Extensions for UserProfile
extension UserProfileExtensions on UserProfile {
  bool get isEmpty => this == UserProfile.empty;
}
