import 'package:flutter/material.dart';
import 'package:rando/components/block.dart';
// import 'package:rando/components/containers/tag_list.dart';
import 'package:rando/components/images/image.dart';
import 'package:rando/pages/activities/activity.dart';
import 'package:rando/services/firestore/item_service.dart';
import 'package:rando/services/models.dart';
import 'package:rando/utils/theme/theme.dart';

class ItemCardWidget extends StatelessWidget {
  final String itemID;
  ItemCardWidget({super.key, required this.itemID});

  final ItemService itemService = ItemService();

  Future<ItemData> getItemData() async {
    return await itemService.getItem(itemID);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ActivityScreen(itemID: itemID),
          ),
        );
      },
      child: BlockWidget(
        inverted: false,
        horizontal: 0,
        vertical: 0,
        child: FutureBuilder<ItemData>(
          future: getItemData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // loading
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // error
              return Center(child: Text("error: ${snapshot.error.toString()}"));
            } else if (snapshot.hasData) {
              // found data
              ItemData item = snapshot.data!;
              return Column(
                verticalDirection: VerticalDirection.down,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: ImageWidget(
                      imgURL: item.imgURL,
                      height: 128,
                      width: double.infinity,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                        Text(
                          item.description,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context).subtextColor,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // TagListWidget(tags: item.tags),
                ],
              );
            } else {
              // no item found in firestore
              return const Text("No Item Found in Firestore. Check Database");
            }
          },
        ),
      ),
    );
  }
}
