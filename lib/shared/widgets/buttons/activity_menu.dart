import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rando/pages/activities/view/add_to_board.dart';
import 'package:rando/pages/activities/view/edit_activity.dart';
import 'package:rando/core/services/item_service.dart';

/// [TODO]
/// add share
/// add or remove items from boards

enum ActivityMenu {
  manage,
  share,
  edit,
  delete,
}

class ActivityMenuButton extends StatelessWidget {
  final String itemID;
  final String imgURL;
  final String userID;
  final bool isOwner;
  final void Function() onDelete;

  const ActivityMenuButton({
    super.key,
    required this.itemID,
    required this.userID,
    required this.imgURL,
    required this.isOwner,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ActivityMenu>(
      itemBuilder: (BuildContext context) => [
        // add activity to a board
        const PopupMenuItem(
          value: ActivityMenu.manage,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.list),
              SizedBox(width: 10),
              Text("Add Or Remove"),
            ],
          ),
        ),

        // share
        const PopupMenuItem(
          value: ActivityMenu.share,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.ios_share),
              SizedBox(width: 10),
              Text("Share"),
            ],
          ),
        ),

        // edit activity
        if (isOwner)
          const PopupMenuItem(
            value: ActivityMenu.edit,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.edit),
                SizedBox(width: 10),
                Text("Edit"),
              ],
            ),
          ),
        if (isOwner)
          const PopupMenuItem(
            value: ActivityMenu.delete,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.delete),
                SizedBox(width: 10),
                Text("Delete"),
              ],
            ),
          ),
      ],
      onSelected: (value) {
        switch (value) {
          // add to or remove from board
          case ActivityMenu.manage:
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddToBoardScreen(
                  itemID: itemID,
                  userID: userID,
                ),
              ),
            );
            break;
          // share!
          case ActivityMenu.share:
            // share activity!
            break;
          // edit activity
          case ActivityMenu.edit:
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditActivityScreen(itemID: itemID),
              ),
            );
            break;
          // delete activity
          case ActivityMenu.delete:
            Navigator.pop(context);
            ItemService().deleteItem(userID, itemID, imgURL);
            onDelete;
            break;
          default:
            break;
        }
      },
    );
  }
}
