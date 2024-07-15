// dart packages
import 'package:flutter/material.dart';

// utils
import 'package:rando/services/auth.dart';
import 'package:rando/services/models.dart';

// components
import 'package:rando/components/activities/item_card.dart';
import 'package:rando/services/firestore/user_service.dart';

class ItemListWidget extends StatefulWidget {
  final String userID;

  const ItemListWidget({super.key, required this.userID});

  @override
  State<ItemListWidget> createState() => _ItemListWidgetState();
}

class _ItemListWidgetState extends State<ItemListWidget> {
  // firestore
  final UserService userService = UserService();

  var currentUser = AuthService().user;

  Future<UserData> getUserData() async {
    return await userService.getUserData(widget.userID);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ItemData>>(
      stream: userService.readUserItemStream(widget.userID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("error: ${snapshot.error.toString()}"));
        } else if (snapshot.hasData) {
          // data found
          List<ItemData> items = snapshot.data!;
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              ItemData item = items[index];
              return ItemCardWidget(item: item);
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
