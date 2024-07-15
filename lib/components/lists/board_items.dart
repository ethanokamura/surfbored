// dart packages
import 'package:flutter/material.dart';

// utils
import 'package:rando/services/auth.dart';
import 'package:rando/services/models.dart';
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ItemData>>(
      stream: boardService.readBoardItemStream(widget.boardID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("error: ${snapshot.error.toString()}"));
        } else if (snapshot.hasData) {
          // data found
          List<ItemData> items = snapshot.data!;
          return Wrap(
            spacing: 20,
            runSpacing: 20,
            children: items.map((item) {
              return SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 30,
                child: ItemCardWidget(item: item),
              );
            }).toList(),
          );
        } else {
          // data is empty..
          return const Text("No Lists Found in Firestore. Check Database");
        }
      },
    );
  }
}
