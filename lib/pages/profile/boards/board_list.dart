// dart packages
import 'package:flutter/material.dart';

// utils
import 'package:rando/core/services/auth_service.dart';
import 'package:rando/core/models/models.dart';
import 'package:rando/core/services/user_service.dart';

// components
import 'package:rando/shared/cards/board_card.dart';

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

  Stream<List<BoardData>> getBoardData() {
    return userService.readUserBoardStream(widget.userID);
  }

  Future<void> refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshData,
      child: StreamBuilder<List<BoardData>>(
        stream: getBoardData(),
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
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: boards.length,
              itemBuilder: (context, index) {
                BoardData board = boards[index];
                return BoardCard(board: board);
              },
            );
          } else {
            // data is empty..
            return const Text("No Lists Found in Firestore. Check Database");
          }
        },
      ),
    );
  }
}
