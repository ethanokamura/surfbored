import 'package:app_core/app_core.dart';
part 'board.g.dart';

@JsonSerializable()
class Board extends Equatable {
  // constructor
  const Board({
    required this.creatorId,
    required this.title,
    this.id = 0,
    this.description = '',
    this.photoUrl,
    this.isPublic = true,
    this.createdAt,
  });

  factory Board.converterSingle(Map<String, dynamic> data) {
    return Board.fromJson(data);
  }

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      id: json[idConverter] as int,
      creatorId: json[creatorIdConverter] as int,
      title: json[titleConverter]?.toString() ?? '',
      description: json[descriptionConverter]?.toString() ?? '',
      photoUrl: json[photoUrlConverter]?.toString() ?? '',
      isPublic: json[isPublicConverter] as bool? ?? true,
      createdAt: json[createdAtConverter] != null
          ? DateTime.tryParse(json[createdAtConverter].toString())
          : DateTime.now().toUtc(),
    );
  }

  static String get idConverter => 'id';
  static String get creatorIdConverter => 'creator_id';
  static String get titleConverter => 'title';
  static String get descriptionConverter => 'description';
  static String get photoUrlConverter => 'photo_url';
  static String get isPublicConverter => 'is_public';
  static String get createdAtConverter => 'created_at';

  static const empty = Board(
    creatorId: 0,
    title: '',
  );

  final int id;
  final int creatorId;
  final String title;
  final String description;
  final String? photoUrl;
  final bool isPublic;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [
        id,
        creatorId,
        title,
        description,
        photoUrl,
        isPublic,
        createdAt,
      ];

  static List<Board> converter(List<Map<String, dynamic>> data) {
    return data.map(Board.fromJson).toList();
  }

  // method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return _generateMap(
      id: id,
      creatorId: creatorId,
      title: title,
      description: description,
      photoUrl: photoUrl,
      isPublic: isPublic,
      createdAt: createdAt,
    );
  }

  static Map<String, dynamic> _generateMap({
    int? id,
    int? creatorId,
    String? title,
    String? description,
    String? photoUrl,
    bool? isPublic,
    DateTime? createdAt,
  }) {
    return {
      if (id != null) idConverter: id,
      if (creatorId != null) creatorIdConverter: creatorId,
      if (title != null) titleConverter: title,
      if (photoUrl != null) photoUrlConverter: photoUrl,
      if (description != null) descriptionConverter: description,
      if (isPublic != null) isPublicConverter: isPublic,
      if (createdAt != null) createdAtConverter: createdAt.toUtc().toString(),
    };
  }

  static Map<String, dynamic> insert({
    int? id,
    int? creatorId,
    String? title,
    String? description,
    String? photoUrl,
    bool? isPublic,
    DateTime? createdAt,
  }) {
    return _generateMap(
      id: id,
      creatorId: creatorId,
      title: title,
      photoUrl: photoUrl,
      description: description,
      isPublic: isPublic,
      createdAt: createdAt,
    );
  }

  static Map<String, dynamic> update({
    int? id,
    int? creatorId,
    String? title,
    String? description,
    String? photoUrl,
    bool? isPublic,
    DateTime? createdAt,
  }) {
    return _generateMap(
      id: id,
      creatorId: creatorId,
      title: title,
      photoUrl: photoUrl,
      description: description,
      isPublic: isPublic,
      createdAt: createdAt,
    );
  }
}

extension BoardExtensions on Board {
  bool get isEmpty => this == Board.empty;
  bool userOwnsBoard(int userId) => creatorId == userId;
}
