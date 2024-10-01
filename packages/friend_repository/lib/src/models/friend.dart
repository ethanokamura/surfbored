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
      userA: json[userAIdConverter] as int,
      userB: json[userBIdConverter] as int,
      createdAt: json[createdAtConverter] != null
          ? DateTime.tryParse(json[createdAtConverter].toString())
          : DateTime.now().toUtc(),
    );
  }

  // data fields
  final int userA;
  final int userB;
  final DateTime? createdAt;

  static String get userAIdConverter => 'user_a_id';
  static String get userBIdConverter => 'user_b_id';
  static String get createdAtConverter => 'created_at';

  static List<Friend> converter(List<Map<String, dynamic>> data) {
    return data.map(Friend.fromJson).toList();
  }

  static Map<String, dynamic> _generateMap({
    int? userA,
    int? userB,
    DateTime? createdAt,
  }) {
    return {
      if (userA != null) userAIdConverter: userA,
      if (userB != null) userBIdConverter: userB,
      if (createdAt != null) createdAtConverter: createdAt.toUtc().toString(),
    };
  }

  static Map<String, dynamic> insert({
    int? userA,
    int? userB,
    DateTime? createdAt,
  }) {
    return _generateMap(
      userA: userA,
      userB: userB,
      createdAt: createdAt,
    );
  }

  static Map<String, dynamic> update({
    int? userA,
    int? userB,
    DateTime? createdAt,
  }) {
    return _generateMap(
      userA: userA,
      userB: userB,
      createdAt: createdAt,
    );
  }

  static const empty = Friend(userA: 0, userB: 0);

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
