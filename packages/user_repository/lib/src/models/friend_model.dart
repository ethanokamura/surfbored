import 'package:api_client/api_client.dart';
import 'package:app_core/app_core.dart';
part 'friend_model.g.dart';

@JsonSerializable()
class Friend extends Equatable {
  const Friend({
    required this.userID1,
    required this.userID2,
    this.createdAt,
  });

  factory Friend.fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);

  factory Friend.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return Friend(
      userID1: data['userID1'] as String? ?? '',
      userID2: data['userID2'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  final String userID1;
  final String userID2;
  @timestamp
  final DateTime? createdAt;

  static const empty = Friend(
    userID1: '',
    userID2: '',
  );

  @override
  List<Object?> get props => [
        userID1,
        userID2,
        createdAt,
      ];

  Map<String, dynamic> toJson() => _$FriendToJson(this);
}
