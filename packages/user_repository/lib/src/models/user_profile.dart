import 'package:app_core/app_core.dart';

class UserProfile extends Equatable {
  const UserProfile({
    required this.username,
    this.photoUrl = '',
  });

  factory UserProfile.converterSingle(Map<String, dynamic> data) {
    return UserProfile.fromJson(data);
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      username: json['username']?.toString() ?? '',
      photoUrl: json['photo_url']?.toString() ?? '',
    );
  }

  static const empty = UserProfile(username: '');

  static List<UserProfile> converter(List<Map<String, dynamic>> data) {
    return data.map(UserProfile.fromJson).toList();
  }

  final String username;
  final String? photoUrl;

  @override
  List<Object?> get props => [username, photoUrl];
}

extension UserProfileExtensions on UserProfile {
  bool get isEmpty => this == UserProfile.empty;
}
