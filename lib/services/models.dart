// utils
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

@JsonSerializable()
class UserData {
  final String id;
  final String username;
  final String name;
  final String imgURL;
  final String bio;
  final String website;
  final List<String> followers;
  final List<String> following;
  final List<String> items;
  final List<String> boards;
  final List<String> likedItems;
  final List<String> likedBoards;
  final String lastOnline;

  // constructor
  UserData({
    this.id = '',
    this.username = '',
    this.name = '',
    this.imgURL = '',
    this.bio = '',
    this.website = '',
    this.followers = const [],
    this.following = const [],
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
      name: data['name'] ?? '',
      imgURL: data['imgURL'] ?? '',
      bio: data['bio'] ?? '',
      website: data['website'] ?? '',
      followers: List<String>.from(data['followers'] ?? []),
      following: List<String>.from(data['following'] ?? []),
      items: List<String>.from(data['items'] ?? []),
      boards: List<String>.from(data['boards'] ?? []),
      likedItems: List<String>.from(data['likedItems'] ?? []),
      likedBoards: List<String>.from(data['likedBoards'] ?? []),
      lastOnline: data['lastOnline'] ?? '',
    );
  }
}

@JsonSerializable()
class BoardData {
  String id;
  final String uid;
  final String imgURL;
  final String title;
  final String description;
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
      likedBy: List<String>.from(data['likedBy'] ?? []),
      items: List<String>.from(data['items'] ?? []),
    );
  }
}

@JsonSerializable()
class ItemData {
  String id;
  String imgURL;
  String uid;
  String title;
  String description;
  int likes;
  List<String> likedBy;
  List<String> tags;

  // constructor
  ItemData({
    this.id = '',
    this.imgURL = '',
    required this.uid,
    required this.title,
    required this.description,
    this.likes = 0,
    this.likedBy = const [],
    this.tags = const [],
  });

  // factory constructor for creating an instance from JSON
  factory ItemData.fromJson(Map<String, dynamic> json) =>
      _$ItemDataFromJson(json);

  // method for converting an instance to JSON
  Map<String, dynamic> toJson() => _$ItemDataToJson(this);

  // factory constructor for creating an instance from firestore doc
  factory ItemData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ItemData(
      id: doc.id, // Firestore document ID
      imgURL: data['imgURL'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      uid: data['uid'] ?? '',
      likes: data['likes'] ?? 0,
      likedBy: List<String>.from(data['likedBy'] ?? []),
      tags: List<String>.from(data['tags'] ?? []),
    );
  }
}
