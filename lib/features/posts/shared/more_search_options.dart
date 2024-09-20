import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:surfbored/features/boards/boards.dart';

enum Options {
  manage,
  share,
}

class MoreSearchOptions extends StatelessWidget {
  const MoreSearchOptions({
    required this.postID,
    required this.userID,
    this.onSurface,
    super.key,
  });

  final String postID;
  final String userID;
  final bool? onSurface;

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(8),
      elevation: 0,
      shadowColor: Colors.black,
      backgroundColor: onSurface != null && onSurface!
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: defaultBorderRadius),
    );
    return PopupMenuButton<Options>(
      style: style,
      itemBuilder: (BuildContext context) => [
        // add activity to a board
        const PopupMenuItem(
          value: Options.manage,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.list),
              SizedBox(width: 10),
              PrimaryText(text: AppStrings.addOrRemove),
            ],
          ),
        ),

        // share
        const PopupMenuItem(
          value: Options.share,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.ios_share),
              SizedBox(width: 10),
              PrimaryText(text: AppStrings.share),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          // add to or remove from board
          case Options.manage:
            Navigator.push(
              context,
              MaterialPageRoute<dynamic>(
                builder: (context) => SelectBoardPage(
                  postID: postID,
                  userID: userID,
                ),
              ),
            );
          // share!
          case Options.share:
            // share activity!
            break;
        }
      },
    );
  }
}
