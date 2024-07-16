import 'package:flutter/material.dart';
import 'package:rando/components/buttons/custom_button.dart';
import 'package:rando/components/images/image.dart';
import 'package:rando/components/lists/board_items.dart';
import 'package:rando/services/firestore/board_service.dart';
import 'package:rando/services/firestore/user_service.dart';
import 'package:rando/services/models.dart';
import 'package:rando/utils/global.dart';
import 'package:rando/utils/theme/theme.dart';

class BoardScreen extends StatefulWidget {
  final BoardData board;
  const BoardScreen({super.key, required this.board});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  BoardService boardService = BoardService();
  String username = '';

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  Future<void> getUsername() async {
    String name = await UserService().getUsername(widget.board.uid);
    setState(() {
      username = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.board.title),
      ),
      body: StreamBuilder<BoardData>(
        stream: boardService.getBoardStream(widget.board.id),
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
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
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
                child: CustomButton(
                  inverted: false,
                  onTap: () {},
                  text: "Edit Board",
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: CustomButton(
                  inverted: false,
                  onTap: () {},
                  text: "Share Board",
                ),
              ),
            ],
          ),
          SizedBox(height: spacing),
          BoardItemsWidget(boardID: boardData.id),
        ],
      ),
    ),
  );
}
