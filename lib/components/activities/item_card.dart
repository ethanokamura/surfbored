import 'package:flutter/material.dart';
import 'package:rando/components/block.dart';
// import 'package:rando/components/containers/tag_list.dart';
import 'package:rando/components/images/image.dart';
import 'package:rando/pages/activities/activity.dart';
import 'package:rando/services/models.dart';
import 'package:rando/utils/theme/theme.dart';

class ItemCardWidget extends StatelessWidget {
  final ItemData item;
  const ItemCardWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActivityScreen(item: item),
          ),
        );
      },
      child: BlockWidget(
        inverted: false,
        horizontal: 10,
        vertical: 10,
        child: Column(
          verticalDirection: VerticalDirection.down,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              child: ImageWidget(
                imgURL: item.imgURL,
                width: double.infinity,
                height: 128,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              item.title,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).textColor,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            // TagListWidget(tags: item.tags),
          ],
        ),
      ),
    );
  }
}
