import 'package:app_core/app_core.dart';

part 'friend_request.g.dart';

@JsonSerializable()
class FriendRequest extends Equatable {
  // FriendRequest data constructor
  const FriendRequest({
    required this.senderId,
    required this.recipientId,
    this.createdAt,
  });

  factory FriendRequest.converterSingle(Map<String, dynamic> data) {
    return FriendRequest.fromJson(data);
  }

  // factory constructor
  // this tells the json serializable what to do
  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(
      senderId: json[senderIdConverter] as int,
      recipientId: json[recipientIdConverter] as int,
      createdAt: json[createdAtConverter] != null
          ? DateTime.tryParse(json[createdAtConverter].toString())
          : DateTime.now().toUtc(),
    );
  }

  // data fields
  final int senderId;
  final int recipientId;
  final DateTime? createdAt;

  static String get senderIdConverter => 'sender_id';
  static String get recipientIdConverter => 'recipient_id';
  static String get createdAtConverter => 'created_at';

  static List<FriendRequest> converter(List<Map<String, dynamic>> data) {
    return data.map(FriendRequest.fromJson).toList();
  }

  static Map<String, dynamic> _generateMap({
    int? senderId,
    int? recipientId,
    DateTime? createdAt,
  }) {
    return {
      if (senderId != null) senderIdConverter: senderId,
      if (recipientId != null) recipientIdConverter: recipientId,
      if (createdAt != null) createdAtConverter: createdAt.toUtc().toString(),
    };
  }

  static Map<String, dynamic> insert({
    int? senderId,
    int? recipientId,
    DateTime? createdAt,
  }) {
    return _generateMap(
      senderId: senderId,
      recipientId: recipientId,
      createdAt: createdAt,
    );
  }

  static Map<String, dynamic> update({
    int? senderId,
    int? recipientId,
    DateTime? createdAt,
  }) {
    return _generateMap(
      senderId: senderId,
      recipientId: recipientId,
      createdAt: createdAt,
    );
  }

  static const empty = FriendRequest(senderId: 0, recipientId: 0);

  @override
  List<Object?> get props => [
        senderId,
        recipientId,
        createdAt,
      ];

  Map<String, dynamic> toJson() {
    return _generateMap(
      senderId: senderId,
      recipientId: recipientId,
      createdAt: createdAt,
    );
  }
}

extension FriendRequestExtensions on FriendRequest {
  bool get isEmpty => this == FriendRequest.empty;
}
