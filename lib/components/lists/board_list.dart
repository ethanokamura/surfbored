// dart packages
import 'package:flutter/material.dart';

// utils
import 'package:rando/services/auth.dart';
import 'package:rando/services/models.dart';
import 'package:rando/services/firestore/user_service.dart';

// components
import 'package:rando/components/boards/board_card.dart';

class BoardListWidget extends StatefulWidget {
  final String userID;
  const BoardListWidget({super.key, required this.userID});

  @override
  State<BoardListWidget> createState() => _BoardListWidgetState();
}

class _BoardListWidgetState extends State<BoardListWidget> {
  // firestore
  final UserService userService = UserService();

  var currentUser = AuthService().user;

  Future<UserData> getUserData() async {
    return await userService.getUserData(widget.userID);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BoardData>>(
      stream: userService.readUserBoardStream(widget.userID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("error: ${snapshot.error.toString()}"));
        } else if (snapshot.hasData) {
          // data found
          List<BoardData> boards = snapshot.data!;
          return ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: boards.length,
              itemBuilder: (context, index) {
                BoardData board = boards[index];
                return BoardCard(board: board);
              });
        } else {
          // data is empty..
          return const Text("No Lists Found in Firestore. Check Database");
        }
      },
    );
  }
}
