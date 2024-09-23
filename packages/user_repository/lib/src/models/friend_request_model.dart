import 'package:api_client/api_client.dart';
import 'package:app_core/app_core.dart';
part 'friend_request_model.g.dart';

@JsonSerializable()
class FriendRequest extends Equatable {
  const FriendRequest({
    required this.senderID,
    required this.recieverID,
    this.createdAt,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json) =>
      _$FriendRequestFromJson(json);

  factory FriendRequest.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;
    return FriendRequest(
      senderID: data['senderID'] as String? ?? '',
      recieverID: data['recieverID'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  final String senderID;
  final String recieverID;
  @timestamp
  final DateTime? createdAt;

  static const empty = FriendRequest(
    senderID: '',
    recieverID: '',
  );

  @override
  List<Object?> get props => [
        senderID,
        recieverID,
        createdAt,
      ];

  Map<String, dynamic> toJson() => _$FriendRequestToJson(this);
}
