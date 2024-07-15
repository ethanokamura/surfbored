import 'package:flutter/material.dart';
import 'package:rando/components/images/image.dart';
import 'package:rando/pages/content/board.dart';
import 'package:rando/services/models.dart';
import 'package:rando/utils/theme/theme.dart';

class BoardCard extends StatefulWidget {
  final BoardData board;
  const BoardCard({super.key, required this.board});

  @override
  State<BoardCard> createState() => _BoardCardState();
}

class _BoardCardState extends State<BoardCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BoardScreen(board: widget.board),
          ),
        );
      },
      child: Material(
        elevation: 10,
        color: Theme.of(context).colorScheme.surface,
        shadowColor: Theme.of(context).shadowColor,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ImageWidget(imgURL: widget.board.imgURL, height: 64, width: 64),
              const SizedBox(width: 20),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.board.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Theme.of(context).textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.board.description,
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
      ),
    );
  }
}
