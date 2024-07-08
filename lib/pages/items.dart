// dart packages
import 'package:flutter/material.dart';

// utils
import 'package:rando/services/firestore.dart';
import 'package:rando/services/models.dart';

// components
import 'package:rando/components/item.dart';

// pages
import 'package:rando/pages/reroute/error.dart';
import 'package:rando/pages/reroute/loading.dart';

// ui libraries
import 'package:rando/utils/theme/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ItemScreen extends StatefulWidget {
  final Board list;
  const ItemScreen({super.key, required this.list});

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  // firestore
  final FirestoreService firestoreService = FirestoreService();

  // text controllers
  final TextEditingController titleTextController = TextEditingController();
  final TextEditingController descTextController = TextEditingController();

  // open a small pop up box
  // String? means the parameter could be null
  void openListBox({String? itemID}) async {
    // If itemID is not null, it means we are editing an existing item
    if (itemID != null) {
      Item item = await firestoreService.getItem(itemID, widget.list.id);
      titleTextController.text = item.title;
      descTextController.text = item.description;
    } else {
      // If itemID is null, clear the text fields for a new item
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
              if (itemID == null) {
                // add a new note
                firestoreService.addItem(titleTextController.text,
                    descTextController.text, widget.list.id);
              } else {
                // update existing
                firestoreService.updateItem(titleTextController.text,
                    descTextController.text, itemID, widget.list.id);
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
    return Scaffold(
      body: StreamBuilder<List<Item>>(
        stream: firestoreService.getItemStream(widget.list),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else if (snapshot.hasError) {
            return ErrorScreen(
              message: snapshot.error.toString(),
            );
          } else if (snapshot.hasData) {
            // data found
            List<Item> items = snapshot.data!;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // back button
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back),
                        ),
                        // logo
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.search,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "PIKIT",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        // menu button
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.settings),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          widget.list.title.toUpperCase(),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          widget.list.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          "@${widget.list.uid}",
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: openListBox,
                            child: const Icon(Icons.add),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Icon(Icons.shuffle),
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
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          Item item = items[index];
                          String itemID = item.id;
                          return ItemWidget(
                            child: ListTile(
                              title: Text(
                                item.title,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              subtitle: Text(
                                item.description,
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              onTap: () {},
                              // onTap: () => Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => ItemScreen(item: item),
                              //   ),
                              // ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // delete
                                  IconButton(
                                    onPressed: () async {
                                      firestoreService.deleteItem(
                                          widget.list, itemID);
                                      widget.list.removeItem(itemID);
                                    },
                                    icon: const Icon(FontAwesomeIcons.trash),
                                    iconSize: 18,
                                  ),
                                  // update
                                  IconButton(
                                    onPressed: () =>
                                        openListBox(itemID: itemID),
                                    icon: const Icon(FontAwesomeIcons.ellipsis),
                                    iconSize: 18,
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
            return const Text("No Items Found in Firestore. Check Database");
          }
        },
      ),
    );
  }
}
