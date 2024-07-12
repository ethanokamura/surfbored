import 'package:flutter/material.dart';
import 'package:rando/services/firestore/user_service.dart';
import 'package:rando/services/models.dart';

class UserDataProvider extends ChangeNotifier {
  final String userID;
  final UserService userService;

  late Stream<UserData> _userDataStream;
  Stream<UserData> get userDataStream => _userDataStream;

  UserDataProvider({required this.userID, required this.userService}) {
    init();
  }

  Future<void> init() async {
    _userDataStream = userService.getUserStream(userID);
    notifyListeners();
  }
}
