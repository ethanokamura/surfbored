import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:surfbored/features/boards/boards.dart';

enum Options {
  manage,
  share,
  edit,
  delete,
}

class MoreOptions extends StatelessWidget {
  const MoreOptions({
    required this.postID,
    required this.userID,
    required this.isOwner,
    required this.onDelete,
    required this.onEdit,
    super.key,
  });

  final String postID;
  final String userID;
  final bool isOwner;
  final void Function() onDelete;
  final void Function() onEdit;

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(8),
      elevation: 0,
      shadowColor: Colors.black,
      backgroundColor: Theme.of(context).colorScheme.surface,
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

        // edit activity
        if (isOwner)
          const PopupMenuItem(
            value: Options.edit,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.edit),
                SizedBox(width: 10),
                PrimaryText(text: AppStrings.edit),
              ],
            ),
          ),
        if (isOwner)
          const PopupMenuItem(
            value: Options.delete,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.delete_outline_outlined),
                SizedBox(width: 10),
                PrimaryText(text: AppStrings.delete),
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
          // edit activity
          case Options.edit:
            onEdit();
          // delete activity
          case Options.delete:
            onDelete();
        }
      },
    );
  }
}
