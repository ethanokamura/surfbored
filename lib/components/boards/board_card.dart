import 'package:flutter/material.dart';
import 'package:rando/components/block.dart';
import 'package:rando/components/images/image.dart';
import 'package:rando/pages/boards/board.dart';
import 'package:rando/services/models.dart';
import 'package:rando/utils/global.dart';
import 'package:rando/utils/theme/theme.dart';

class BoardCard extends StatelessWidget {
  final BoardData board;
  const BoardCard({super.key, required this.board});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BoardScreen(board: board),
          ),
        );
      },
      child: BlockWidget(
        inverted: false,
        horizontal: null,
        vertical: null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImageWidget(
              borderRadius: borderRadius,
              imgURL: board.imgURL,
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
                    board.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Theme.of(context).textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    board.description,
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
          ],
        ),
      ),
    );
  }
}
