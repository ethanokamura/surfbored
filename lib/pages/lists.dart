// dart packages
import 'package:flutter/material.dart';

// utils
import 'package:rando/services/auth.dart';
import 'package:rando/utils/theme/theme_provider.dart';
import 'package:rando/services/firestore.dart';
import 'package:rando/services/models.dart';
import 'package:provider/provider.dart';

// components
import 'package:rando/components/containers/item.dart';
import 'package:rando/components/bottom_nav.dart';

// pages
import 'package:rando/pages/reroute/error.dart';
import 'package:rando/pages/reroute/loading.dart';
import 'package:rando/pages/profile/profile.dart';
import 'package:rando/pages/items.dart';

// ui libraries
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ListScreen extends StatefulWidget {
  final String userID;
  const ListScreen({super.key, required this.userID});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
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
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: StreamBuilder<List<Board>>(
        stream: firestoreService.getListStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else if (snapshot.hasError) {
            return ErrorScreen(
              message: snapshot.error.toString(),
            );
          } else if (snapshot.hasData) {
            // data found
            List<Board> lists = snapshot.data!;
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProfileScreen(userID: currentUser!.uid),
                              ),
                            );
                          },
                          child: const Icon(Icons.person),
                        ),
                        Text(
                          "My Lists",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Switch(
                          value: themeProvider.isDarkMode,
                          onChanged: (value) => themeProvider.toggleTheme(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (widget.userID == currentUser!.uid)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: openListBox,
                              child: const Icon(
                                FontAwesomeIcons.plus,
                                size: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.separated(
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
                                    builder: (context) =>
                                        ItemScreen(list: list),
                                  ),
                                );
                              },
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // delete
                                  IconButton(
                                    onPressed: () =>
                                        firestoreService.deleteList(listID),
                                    icon: const Icon(FontAwesomeIcons.trash),
                                    iconSize: 15,
                                  ),
                                  // update
                                  IconButton(
                                    onPressed: () =>
                                        openListBox(listID: listID),
                                    icon: const Icon(
                                        FontAwesomeIcons.ellipsisVertical),
                                    iconSize: 15,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // data is empty..
            return const Text("No Lists Found in Firestore. Check Database");
          }
        },
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
