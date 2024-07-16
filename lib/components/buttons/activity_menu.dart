import 'package:flutter/material.dart';
import 'package:rando/pages/activities/add_to_board.dart';
import 'package:rando/pages/activities/edit_activity.dart';

/// [TODO]
/// add share
/// add or remove items from boards

enum ActivityMenu {
  manage,
  share,
  edit,
}

class ActivityMenuButton extends StatelessWidget {
  final String itemID;
  final String userID;
  final bool isOwner;

  const ActivityMenuButton({
    super.key,
    required this.itemID,
    required this.userID,
    required this.isOwner,
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
      ],
      onSelected: (value) {
        switch (value) {
          // add to or remove from board
          case ActivityMenu.manage:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddToBoardScreen(userID: userID),
              ),
            );
            break;
          // share!
          case ActivityMenu.share:
            // share activity!
            break;
          // edit activity
          case ActivityMenu.edit:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditActivityScreen(itemID: itemID),
              ),
            );
            break;
          default:
            break;
        }
      },
    );
  }
}
