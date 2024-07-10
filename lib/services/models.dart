// utils
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

// ITEMLIST
@JsonSerializable()
class UserData {
  final String id;
  final String username;
  final String imgURL;
  final String bio;
  final String website;
  final List<Board> boards;
  final List<Item> items;
  final String lastOnline;

  // constructor
  UserData({
    this.id = '',
    this.username = '',
    this.imgURL = '',
    this.bio = '',
    this.website = '',
    this.boards = const [],
    this.items = const [],
    this.lastOnline = '',
  });

  // factory constructor
  // this tells the json serializable what to do
  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  // allows for an easy way to stream data
  factory UserData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<Item> items =
        (data['items'] as List).map((item) => Item.fromJson(item)).toList();
    List<Board> boards =
        (data['boards'] as List).map((board) => Board.fromJson(board)).toList();

    return UserData(
      id: doc.id,
      username: data['username'] ?? '',
      imgURL: data['imgURL'] ?? '',
      bio: data['bio'] ?? '',
      website: data['website'] ?? '',
      boards: boards,
      items: items,
      lastOnline: data['lastOnline'] ?? '',
    );
  }
}

// ITEMLIST
@JsonSerializable()
class Board {
  String id;
  final String imgURL;
  final String title;
  final String description;
  final String uid;
  final int likes;
  final List<Item> items;

  // constructor
  Board({
    this.id = '',
    this.uid = '',
    this.imgURL = '',
    this.title = '',
    this.description = '',
    this.likes = 0,
    this.items = const [],
  });

  // factory constructor
  // this tells the json serializable what to do
  factory Board.fromJson(Map<String, dynamic> json) => _$BoardFromJson(json);
  Map<String, dynamic> toJson() => _$BoardToJson(this);

  // allows for an easy way to stream data
  factory Board.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<Item> items =
        (data['items'] as List).map((item) => Item.fromJson(item)).toList();
    return Board(
      id: doc.id,
      uid: data['uid'] ?? '',
      imgURL: data['imgURL'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      likes: data['likes'] ?? 0,
      items: items,
    );
  }
  void removeItem(String itemID) {
    items.removeWhere((item) => item.id == itemID);
  }
}

// ITEM
@JsonSerializable()
class Item {
  String id;
  final String imgURL;
  final String title;
  final String description;
  final String uid;
  final List<String> tags;
  final int likes;

  // constructor
  Item({
    this.id = '',
    this.imgURL = '',
    this.title = '',
    this.description = '',
    this.uid = '',
    this.likes = 0,
    this.tags = const [],
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
  Map<String, dynamic> toJson() => _$ItemToJson(this);
  factory Item.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Item(
      id: doc.id, // Firestore document ID
      imgURL: data['imgURL'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      uid: data['uid'] ?? '',
      likes: data['likes'] ?? 0,
      tags: data['tags'] ?? [],
    );
  }
}
