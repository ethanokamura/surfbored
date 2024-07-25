import 'package:api_client/api_client.dart';
import 'package:app_core/app_core.dart';
part 'models.g.dart';

@JsonSerializable()
class Item extends Equatable {
  // constructor
  const Item({
    required this.uid,
    required this.title,
    this.id = '',
    this.likes = 0,
    this.likedBy = const [],
    this.tags = const [],
    this.photoURL = '',
    this.description = '',
    this.createdAt,
  });

  // factory constructor for creating an instance from JSON
  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  // data fields
  final String id;
  final String? photoURL;
  final String uid;
  final String title;
  final String description;
  final int likes;
  final List<String> likedBy;
  final List<String> tags;
  @timestamp
  final DateTime? createdAt;

  static const empty = Item(
    id: '',
    uid: '',
    title: '',
  );

  @override
  List<Object?> get props => [
        id,
        title,
        photoURL,
        uid,
        description,
        likes,
        likedBy,
        tags,
        createdAt,
      ];

  // method for converting an instance to JSON
  Map<String, dynamic> toJson() => _$ItemToJson(this);
}

extension ItemExtensions on Item {
  bool get isEmpty => this == Item.empty;
  int totalLikes() => likes;
}
