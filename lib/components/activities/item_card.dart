import 'package:flutter/material.dart';
// import 'package:rando/components/containers/tag_list.dart';
import 'package:rando/components/images/image.dart';
import 'package:rando/pages/activities/activity.dart';
import 'package:rando/services/models.dart';
import 'package:rando/utils/default_image_config.dart';
import 'package:rando/utils/theme/theme.dart';

class ItemCardWidget extends StatelessWidget {
  final Item item;
  const ItemCardWidget({super.key, required this.item});

  String getPhotoURL(String photoURL) {
    return (photoURL == '') ? DefaultImageConfig().profileIMG : photoURL;
  }

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
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageWidget(
                imgURL: getPhotoURL(item.imgURL),
                width: 128,
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
