// dart packages
import 'package:flutter/material.dart';

// utils
import 'package:rando/services/auth.dart';
import 'package:rando/services/firestore.dart';
import 'package:rando/services/models.dart';

// components
import 'package:rando/components/containers/item.dart';

// pages
// import 'package:rando/pages/items.dart';

// ui libraries
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ItemListWidget extends StatefulWidget {
  final String userID;

  const ItemListWidget({super.key, required this.userID});

  @override
  State<ItemListWidget> createState() => _ItemListWidgetState();
}

class _ItemListWidgetState extends State<ItemListWidget> {
  // firestore
  final FirestoreService firestoreService = FirestoreService();

  var currentUser = AuthService().user;

  Future<UserData> getUserData() async {
    return await firestoreService.getUserDetails(widget.userID);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Item>>(
      stream: firestoreService.readItemStream(widget.userID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("error: ${snapshot.error.toString()}"));
        } else if (snapshot.hasData) {
          // data found
          List<Item> items = snapshot.data!;
          return ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              Item item = items[index];
              // String itemID = item.id;
              return ItemWidget(
                child: ListTile(
                  title: Text(item.title),
                  subtitle: Text(
                    item.description,
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                  ),
                  onTap: () {},
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // delete
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(FontAwesomeIcons.trash),
                        iconSize: 15,
                      ),
                      // update
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(FontAwesomeIcons.ellipsisVertical),
                        iconSize: 15,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          // data is empty..
          return const Text("No Lists Found in Firestore. Check Database");
        }
      },
    );
  }
}
