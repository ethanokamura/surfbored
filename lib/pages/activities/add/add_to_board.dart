// dart packages
import 'package:flutter/material.dart';

// utils
import 'package:rando/core/services/auth_service.dart';
import 'package:rando/core/models/models.dart';
import 'package:rando/core/services/user_service.dart';

// components
import 'package:rando/pages/activities/add/widgets/select_board.dart';

class AddToBoardScreen extends StatefulWidget {
  final String userID;
  final String itemID;
  const AddToBoardScreen({
    super.key,
    required this.itemID,
    required this.userID,
  });

  @override
  State<AddToBoardScreen> createState() => _AddToBoardScreenState();
}

class _AddToBoardScreenState extends State<AddToBoardScreen> {
  // firestore
  final UserService userService = UserService();

  var currentUser = AuthService().user;

  Future<UserData> getUserData() async {
    return await userService.getUserData(widget.userID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Activity To A Board"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        child: const Icon(Icons.check_rounded),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: StreamBuilder<List<BoardData>>(
            stream: userService.readUserBoardStream(widget.userID),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                    child: Text("error: ${snapshot.error.toString()}"));
              } else if (snapshot.hasData) {
                // data found
                List<BoardData> boards = snapshot.data!;
                return ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemCount: boards.length,
                    itemBuilder: (context, index) {
                      BoardData board = boards[index];
                      return SelectBoardCard(
                        itemID: widget.itemID,
                        board: board,
                      );
                    });
              } else {
                // data is empty..
                return const Text(
                    "No Lists Found in Firestore. Check Database");
              }
            },
          ),
        ),
      ),
    );
  }
}
