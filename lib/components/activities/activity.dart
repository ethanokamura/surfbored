import 'package:flutter/material.dart';
import 'package:rando/components/buttons/like_button.dart';
import 'package:rando/components/containers/tag_list.dart';
import 'package:rando/components/buttons/link.dart';
import 'package:rando/pages/profile/profile.dart';
import 'package:rando/services/auth.dart';
import 'package:rando/services/firestore/item_service.dart';
import 'package:rando/services/models.dart';
import 'package:rando/components/images/image.dart';
import 'package:rando/services/firestore/user_service.dart';
import 'package:rando/utils/theme/theme.dart';

class ActivityWidget extends StatefulWidget {
  final ItemData item;
  const ActivityWidget({super.key, required this.item});

  @override
  State<ActivityWidget> createState() => _ActivityWidgetState();
}

class _ActivityWidgetState extends State<ActivityWidget> {
  AuthService auth = AuthService();
  UserService userService = UserService();
  ItemService itemService = ItemService();
  bool isLiked = false;
  String username = '';
  late Stream<ItemData> itemStream;

  @override
  void initState() {
    super.initState();
    checkLiked();
    getUsername();
    itemStream = itemService.getItemStream(widget.item.id);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> checkAuth() async {
    var user = auth.user!;
    return user.uid == widget.item.uid;
  }

  Future<void> checkLiked() async {
    var user = auth.user!;
    bool liked = await userService.userLikesItem(user.uid, widget.item.id);
    if (mounted) setState(() => isLiked = liked);
  }

  Future<void> getUsername() async {
    String name = await userService.getUsername(widget.item.uid);
    if (mounted) setState(() => username = name);
  }

  void toggleLike() {
    if (mounted) setState(() => isLiked = !isLiked);
    itemService.updateItemLikes(auth.user!.uid, widget.item.id, isLiked);
  }

  @override
  Widget build(BuildContext context) {
    double spacing = 15;
    return StreamBuilder<ItemData>(
      stream: itemStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("Item Not Found."));
        }

        ItemData itemData = snapshot.data!;
        return Center(
          child: Material(
            elevation: 10,
            color: Theme.of(context).colorScheme.surface,
            shadowColor: Theme.of(context).shadowColor,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        itemData.title,
                        style: TextStyle(
                          color: Theme.of(context).textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Icon(Icons.more_horiz),
                      ),
                    ],
                  ),
                  SizedBox(height: spacing),
                  ImageWidget(
                    imgURL: itemData.imgURL,
                    width: double.infinity,
                    height: 256,
                  ),
                  SizedBox(height: spacing),
                  Text(
                    itemData.description,
                    style: TextStyle(
                      color: Theme.of(context).subtextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: spacing),
                  TagListWidget(tags: itemData.tags),
                  SizedBox(height: spacing),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      LinkWidget(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfileScreen(userID: itemData.uid),
                          ),
                        ),
                        text: '@$username',
                      ),
                      LikeButton(
                        likes: itemData.likes,
                        isLiked: isLiked,
                        onTap: toggleLike,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
