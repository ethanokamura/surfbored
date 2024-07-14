import 'package:flutter/material.dart';
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
      child: Material(
        elevation: 15,
        color: Theme.of(context).colorScheme.surface,
        shadowColor: Theme.of(context).shadowColor,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImageWidget(
                imgURL: item.imgURL,
                width: double.infinity,
                height: 96,
              ),
              const SizedBox(height: 10),
              Text(
                item.title,
                maxLines: 1,
                style: TextStyle(
                  color: Theme.of(context).textColor,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              // TagListWidget(tags: item.tags),
            ],
          ),
        ),
      ),
    );
  }
}
