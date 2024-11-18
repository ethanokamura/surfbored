import 'package:app_core/app_core.dart';

class BoardSave extends Equatable {
  const BoardSave({
    required this.userId,
    required this.boardId,
    this.createdAt,
  });

  factory BoardSave.converterSingle(Map<String, dynamic> data) {
    return BoardSave.fromJson(data);
  }

  factory BoardSave.fromJson(Map<String, dynamic> json) {
    return BoardSave(
      userId: json[userIdConverter]?.toString() ?? '',
      boardId: json[boardIdConverter] as int,
      createdAt: json[createdAtConverter] != null
          ? DateTime.tryParse(json[createdAtConverter].toString())?.toUtc()
          : DateTime.now().toUtc(),
    );
  }

  static String get userIdConverter => 'user_id';
  static String get boardIdConverter => 'board_id';
  static String get createdAtConverter => 'created_at';

  static const empty = BoardSave(userId: '', boardId: 0);

  final String userId;
  final int boardId;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [
        userId,
        boardId,
        createdAt,
      ];

  static List<BoardSave> converter(List<Map<String, dynamic>> data) {
    return data.map(BoardSave.fromJson).toList();
  }

  // method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return _generateMap(
      userId: userId,
      boardId: boardId,
      createdAt: createdAt,
    );
  }

  static Map<String, dynamic> _generateMap({
    String? userId,
    int? boardId,
    DateTime? createdAt,
  }) {
    return {
      if (userId != null) userIdConverter: userId,
      if (boardId != null) boardIdConverter: boardId,
      if (createdAt != null) createdAtConverter: createdAt.toUtc().toString(),
    };
  }

  static Map<String, dynamic> insert({
    String? userId,
    int? boardId,
    int? title,
    DateTime? createdAt,
  }) {
    return _generateMap(
      userId: userId,
      boardId: boardId,
      createdAt: createdAt,
    );
  }

  static Map<String, dynamic> update({
    String? userId,
    int? boardId,
    int? title,
    DateTime? createdAt,
  }) {
    return _generateMap(
      userId: userId,
      boardId: boardId,
      createdAt: createdAt,
    );
  }
}

extension BoardSaveExtensions on BoardSave {
  bool get isEmpty => this == BoardSave.empty;
}
