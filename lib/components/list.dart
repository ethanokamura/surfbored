// dart packages
import 'package:flutter/material.dart';

// utils
import 'package:rando/services/auth.dart';
import 'package:rando/services/firestore.dart';
import 'package:rando/services/models.dart';

// components
import 'package:rando/components/containers/item.dart';

// pages
import 'package:rando/pages/items.dart';

// ui libraries
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyList extends StatefulWidget {
  final String userID;

  const MyList({super.key, required this.userID});

  @override
  State<MyList> createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  // firestore
  final FirestoreService firestoreService = FirestoreService();

  // text controllers
  final TextEditingController titleTextController = TextEditingController();
  final TextEditingController descTextController = TextEditingController();

  var currentUser = AuthService().user;

  Future<UserData> getUserData() async {
    return await firestoreService.getUserDetails(widget.userID);
  }

  // add item list
  Future<void> addItemList(String title, String description) async {
    // Example item list to add
    Board newItemList = Board(
      title: title,
      description: description,
      uid: currentUser!.uid,
      items: [],
    );
    await firestoreService.addList(newItemList);
  }

  // update item list
  Future<void> updateItemList(
      String title, String description, String listID) async {
    Board updatedList = Board(
      uid: currentUser!.uid,
      title: title,
      description: description,
    );
    await firestoreService.updateList(updatedList, listID);
  }

  // open a small pop up box
  // String? means the parameter could be null
  void openListBox({String? listID}) async {
    // If listID is not null, it means we are editing an existing item
    if (listID != null) {
      Board list = await firestoreService.getList(listID);
      titleTextController.text = list.title;
      descTextController.text = list.description;
    } else {
      // If listID is null, clear the text fields for a new item
      titleTextController.clear();
      descTextController.clear();
    }
    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (context) => AlertDialog(
        // text user input
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleTextController,
                decoration: const InputDecoration(
                  hintText: 'title',
                ),
              ),
              TextFormField(
                controller: descTextController,
                decoration: const InputDecoration(
                  hintText: 'description',
                ),
              ),
            ],
          ),
        ),
        actions: [
          // button to save
          ElevatedButton(
            onPressed: () {
              if (listID == null) {
                // add a new note
                addItemList(titleTextController.text, descTextController.text);
              } else {
                // update existing
                updateItemList(
                    titleTextController.text, descTextController.text, listID);
              }
              // clear text controllers
              titleTextController.clear();
              descTextController.clear();
              // close the box
              Navigator.pop(context);
            },
            child: const Text("Add"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Board>>(
      stream: firestoreService.getListStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else if (snapshot.hasData) {
          // data found
          List<Board> lists = snapshot.data!;
          return ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
            itemCount: lists.length,
            itemBuilder: (context, index) {
              Board list = lists[index];
              String listID = list.id;
              return ItemWidget(
                child: ListTile(
                  title: Text(
                    list.title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  subtitle: Text(
                    list.description,
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemScreen(list: list),
                      ),
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // delete
                      IconButton(
                        onPressed: () => firestoreService.deleteList(listID),
                        icon: const Icon(FontAwesomeIcons.trash),
                        iconSize: 15,
                      ),
                      // update
                      IconButton(
                        onPressed: () => openListBox(listID: listID),
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
