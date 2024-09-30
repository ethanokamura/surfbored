import 'package:app_core/app_core.dart';

part 'friend.g.dart';

@JsonSerializable()
class Friend extends Equatable {
  // Friend data constructor
  const Friend({
    required this.userA,
    required this.userB,
    this.createdAt,
  });

  factory Friend.converterSingle(Map<String, dynamic> data) {
    return Friend.fromJson(data);
  }

  // factory constructor
  // this tells the json serializable what to do
  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      userA: json['user_a_id'] != null ? json['user_a_id'].toString() : '',
      userB: json['user_b_id'] != null ? json['user_b_id'].toString() : '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())!
          : null,
    );
  }

  // data fields
  final String userA;
  final String userB;
  final DateTime? createdAt;

  static String get userAIdConverter => 'user_a_id';
  static String get userBIdConverter => 'user_b_id';
  static String get createdAtConverter => 'created_at';

  static List<Friend> converter(List<Map<String, dynamic>> data) {
    return data.map(Friend.fromJson).toList();
  }

  static Map<String, dynamic> _generateMap({
    String? userA,
    String? userB,
    DateTime? createdAt,
  }) {
    return {
      if (userA != null) 'user_a_id': userA,
      if (userB != null) 'user_b_id': userB,
      if (createdAt != null) 'created_at': createdAt.toUtc().toString(),
    };
  }

  static Map<String, dynamic> insert({
    String? userA,
    String? userB,
    DateTime? createdAt,
  }) {
    return _generateMap(
      userA: userA,
      userB: userB,
      createdAt: createdAt,
    );
  }

  static Map<String, dynamic> update({
    String? userA,
    String? userB,
    DateTime? createdAt,
  }) {
    return _generateMap(
      userA: userA,
      userB: userB,
      createdAt: createdAt,
    );
  }

  static const empty = Friend(userA: '', userB: '');

  @override
  List<Object?> get props => [
        userA,
        userB,
        createdAt,
      ];

  Map<String, dynamic> toJson() {
    return _generateMap(
      userA: userA,
      userB: userB,
      createdAt: createdAt,
    );
  }
}

extension FriendExtensions on Friend {
  bool get isEmpty => this == Friend.empty;
}
