// utils
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

@JsonSerializable()
class UserData {
  final String id;
  final String username;
  final String imgURL;
  final String bio;
  final String website;
  final List<String> items;
  final List<String> boards;
  final List<String> likedItems;
  final List<String> likedBoards;
  final String lastOnline;

  // constructor
  UserData({
    this.id = '',
    this.username = '',
    this.imgURL = '',
    this.bio = '',
    this.website = '',
    this.items = const [],
    this.boards = const [],
    this.likedItems = const [],
    this.likedBoards = const [],
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
    return UserData(
      id: doc.id,
      username: data['username'] ?? '',
      imgURL: data['imgURL'] ?? '',
      bio: data['bio'] ?? '',
      website: data['website'] ?? '',
      items: data['items'] ?? [],
      boards: data['boards'] ?? [],
      likedItems: data['likedItems'] ?? [],
      likedBoards: data['likedBoards'] ?? [],
      lastOnline: data['lastOnline'] ?? '',
    );
  }
}

@JsonSerializable()
class BoardData {
  String id;
  final String imgURL;
  final String title;
  final String description;
  final String uid;
  final int likes;
  final List<String> likedBy;
  final List<String> items;

  // constructor
  BoardData({
    this.id = '',
    this.uid = '',
    this.imgURL = '',
    this.title = '',
    this.description = '',
    this.likes = 0,
    this.likedBy = const [],
    this.items = const [],
  });

  // factory constructor
  // this tells the json serializable what to do
  factory BoardData.fromJson(Map<String, dynamic> json) =>
      _$BoardDataFromJson(json);
  Map<String, dynamic> toJson() => _$BoardDataToJson(this);

  // allows for an easy way to stream data
  factory BoardData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return BoardData(
      id: doc.id,
      uid: data['uid'] ?? '',
      imgURL: data['imgURL'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      likes: data['likes'] ?? 0,
      likedBy: data['likedBy'] ?? [],
      items: data['items'] ?? [],
    );
  }
}

@JsonSerializable()
class ItemData {
  String id;
  final String imgURL;
  final String title;
  final String description;
  final String uid;
  final int likes;
  final List<String> likedBy;
  final List<String> tags;

  // constructor
  ItemData({
    this.id = '',
    this.imgURL = '',
    this.title = '',
    this.description = '',
    this.uid = '',
    this.likes = 0,
    this.likedBy = const [],
    this.tags = const [],
  });

  factory ItemData.fromJson(Map<String, dynamic> json) =>
      _$ItemDataFromJson(json);
  Map<String, dynamic> toJson() => _$ItemDataToJson(this);
  factory ItemData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ItemData(
      id: doc.id, // Firestore document ID
      imgURL: data['imgURL'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      uid: data['uid'] ?? '',
      likes: data['likes'] ?? 0,
      likedBy: data['likedBy'] ?? [],
      tags: List<String>.from(data['tags'] ?? []),
    );
  }
}
