import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rando/shared/widgets/buttons/defualt_button.dart';
import 'package:rando/shared/images/image.dart';
import 'package:rando/pages/boards/widgets/board_items.dart';
import 'package:rando/pages/boards/shuffle/shuffle_items.dart';
import 'package:rando/pages/boards/edit/edit_board.dart';
import 'package:rando/core/services/board_service.dart';
import 'package:rando/core/services/user_service.dart';
import 'package:rando/core/models/models.dart';
import 'package:rando/config/global.dart';
import 'package:rando/config/theme.dart';

class BoardScreen extends StatefulWidget {
  final String boardID;
  final String userID;

  const BoardScreen({
    super.key,
    required this.boardID,
    required this.userID,
  });

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  BoardService boardService = BoardService();
  String username = '';
  late List<ItemData> itemList;

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  Future<void> getUsername() async {
    String name = await UserService().getUsername(widget.userID);
    setState(() {
      username = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<BoardData>(
        stream: boardService.getBoardStream(widget.boardID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Item Not Found."));
          }

          BoardData boardData = snapshot.data!;
          return buildBoardScreen(context, boardData, boardService, username);
        },
      ),
    );
  }
}

Widget buildBoardScreen(
  BuildContext context,
  BoardData boardData,
  BoardService boardService,
  String username,
) {
  double spacing = 20;
  return SingleChildScrollView(
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DefualtButton(
                  horizontal: 0,
                  vertical: 0,
                  inverted: false,
                  onTap: () => Navigator.pop(context),
                  icon: CupertinoIcons.back,
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: AutoSizeText(
                    '${boardData.title}:',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                DefualtButton(
                  horizontal: 0,
                  vertical: 0,
                  inverted: false,
                  onTap: () {}, // settings
                  icon: Icons.more_horiz,
                ),
              ],
            ),
            SizedBox(height: spacing),
            ImageWidget(
              borderRadius: borderRadius,
              imgURL: boardData.imgURL,
              height: 256,
              width: double.infinity,
            ),
            SizedBox(height: spacing),
            Text(
              boardData.title,
              style: TextStyle(
                color: Theme.of(context).textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              boardData.description,
              style: TextStyle(
                color: Theme.of(context).subtextColor,
              ),
            ),
            Text(
              '@$username',
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
            SizedBox(height: spacing),
            Row(
              children: [
                Expanded(
                  child: DefualtButton(
                    inverted: false,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditBoardScreen(boardID: boardData.id),
                      ),
                    ),
                    text: "Edit Board",
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: DefualtButton(
                    inverted: false,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ShuffleItemScreen(boardID: boardData.id),
                      ),
                    ),
                    text: "Shuffle",
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing),
            BoardItemsWidget(boardID: boardData.id),
          ],
        ),
      ),
    ),
  );
}
