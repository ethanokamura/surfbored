import 'package:flutter/material.dart';
import 'package:rando/components/activities/activity.dart';
import 'package:rando/components/buttons/custom_button.dart';
import 'package:rando/services/auth.dart';
import 'package:rando/services/firestore/item_service.dart';
import 'package:rando/services/models.dart';
import 'package:rando/services/firestore/user_service.dart';

class ActivityScreen extends StatefulWidget {
  final ItemData item;
  const ActivityScreen({super.key, required this.item});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  AuthService auth = AuthService();
  UserService userService = UserService();
  ItemService itemService = ItemService();
  bool isLiked = false;
  String username = '';
  late Stream<ItemData> itemStream;

  Future<bool> checkAuth() async {
    var user = auth.user!;
    return user.uid == widget.item.uid;
  }

  Future<void> checkLiked() async {
    var user = auth.user!;
    bool liked = await userService.userLikesItem(user.uid, widget.item.id);
    setState(() {
      isLiked = liked;
    });
  }

  Future<void> getUsername() async {
    String name = await userService.getUsername(widget.item.uid);
    setState(() {
      username = name;
    });
  }

  @override
  void initState() {
    super.initState();
    checkLiked();
    getUsername();
    itemStream = itemService.getItemStream(widget.item.id);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
    itemService.updateItemLikes(auth.user!.uid, widget.item.id, isLiked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.title),
      ),
      body: StreamBuilder<ItemData>(
        stream: itemStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Item Not Found."));
          }

          ItemData itemData = snapshot.data!;
          return SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ActivityWidget(item: itemData),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            inverted: false,
                            onTap: () {},
                            text: 'X',
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: CustomButton(
                            inverted: true,
                            onTap: () {},
                            icon: Icons.favorite,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
