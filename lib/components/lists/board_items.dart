// dart packages
import 'package:flutter/material.dart';

// utils
import 'package:rando/services/auth.dart';
import 'package:rando/services/firestore/board_service.dart';

// components
import 'package:rando/components/activities/item_card.dart';

class BoardItemsWidget extends StatefulWidget {
  final String boardID;

  const BoardItemsWidget({super.key, required this.boardID});

  @override
  State<BoardItemsWidget> createState() => _BoardItemsWidgetState();
}

class _BoardItemsWidgetState extends State<BoardItemsWidget> {
  // firestore
  final BoardService boardService = BoardService();

  var currentUser = AuthService().user;

  Future<List<String>> getItemIds() async {
    return await boardService.getBoardItemsID(widget.boardID);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: getItemIds(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("error: ${snapshot.error.toString()}"));
        } else if (snapshot.hasData) {
          // data found
          List<String> itemIDs = snapshot.data!;
          if (itemIDs.isEmpty) {
            return const Center(
              child: Text("User has not created an activity yet!"),
            );
          } else {
            return Wrap(
              spacing: 20,
              runSpacing: 20,
              children: itemIDs.map((itemID) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 30,
                  child: ItemCardWidget(itemID: itemID),
                );
              }).toList(),
            );
          }
        } else {
          // data is empty..
          return const Text("No Lists Found in Firestore. Check Database");
        }
      },
    );
  }
}
