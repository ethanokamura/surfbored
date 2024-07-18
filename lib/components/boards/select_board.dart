import 'package:flutter/material.dart';
import 'package:rando/components/block.dart';
import 'package:rando/components/buttons/check_box.dart';
import 'package:rando/components/images/image.dart';
import 'package:rando/services/firestore/board_service.dart';
import 'package:rando/services/models.dart';
import 'package:rando/utils/global.dart';
import 'package:rando/utils/theme/theme.dart';

class SelectBoardCard extends StatefulWidget {
  final BoardData board;
  final String itemID;
  const SelectBoardCard({super.key, required this.itemID, required this.board});

  @override
  State<SelectBoardCard> createState() => _SelectBoardCardState();
}

class _SelectBoardCardState extends State<SelectBoardCard> {
  BoardService boardService = BoardService();
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    checkIncluded();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> checkIncluded() async {
    bool selected =
        await boardService.boardIncludesItem(widget.board.id, widget.itemID);
    if (mounted) setState(() => _isSelected = selected);
  }

  void toggleSelect() {
    if (mounted) setState(() => _isSelected = !_isSelected);
    boardService.updateBoardItems(
      widget.board.id,
      widget.itemID,
      _isSelected,
    );
  }

  Stream<BoardData> getBoardDataStream() {
    return boardService.getBoardStream(widget.board.id);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getBoardDataStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("Item Not Found."));
        }

        BoardData boardData = snapshot.data!;
        return BlockWidget(
          inverted: false,
          horizontal: null,
          vertical: null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ImageWidget(
                borderRadius: borderRadius,
                imgURL: boardData.imgURL,
                height: 64,
                width: 64,
              ),
              const SizedBox(width: 20),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      boardData.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      boardData.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).subtextColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              CheckBox(isSelected: _isSelected, onTap: toggleSelect),
            ],
          ),
        );
      },
    );
  }
}
