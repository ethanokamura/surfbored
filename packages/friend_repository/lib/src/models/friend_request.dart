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
      senderId: json['sender_id'] != null ? json['sender_id'].toString() : '',
      recipientId:
          json['recipient_id'] != null ? json['recipient_id'].toString() : '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())!
          : null,
    );
  }

  // data fields
  final String senderId;
  final String recipientId;
  final DateTime? createdAt;

  static String get senderIdConverter => 'sender_id';
  static String get recipientIdConverter => 'recipient_id';
  static String get createdAtConverter => 'created_at';

  static List<FriendRequest> converter(List<Map<String, dynamic>> data) {
    return data.map(FriendRequest.fromJson).toList();
  }

  static Map<String, dynamic> _generateMap({
    String? senderId,
    String? recipientId,
    DateTime? createdAt,
  }) {
    return {
      if (senderId != null) 'sender_id': senderId,
      if (recipientId != null) 'recipient_id': recipientId,
      if (createdAt != null) 'created_at': createdAt.toUtc().toString(),
    };
  }

  static Map<String, dynamic> insert({
    String? senderId,
    String? recipientId,
    DateTime? createdAt,
  }) {
    return _generateMap(
      senderId: senderId,
      recipientId: recipientId,
      createdAt: createdAt,
    );
  }

  static Map<String, dynamic> update({
    String? senderId,
    String? recipientId,
    DateTime? createdAt,
  }) {
    return _generateMap(
      senderId: senderId,
      recipientId: recipientId,
      createdAt: createdAt,
    );
  }

  static const empty = FriendRequest(senderId: '', recipientId: '');

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
