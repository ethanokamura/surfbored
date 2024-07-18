import 'package:flutter/material.dart';
import 'package:rando/components/buttons/like_button.dart';
import 'package:rando/components/buttons/activity_menu.dart';
import 'package:rando/components/block.dart';
import 'package:rando/components/lists/tag_list.dart';
import 'package:rando/components/link.dart';
import 'package:rando/pages/profile/profile.dart';
import 'package:rando/services/auth.dart';
import 'package:rando/services/firestore/item_service.dart';
import 'package:rando/services/models.dart';
import 'package:rando/components/images/image.dart';
import 'package:rando/services/firestore/user_service.dart';
import 'package:rando/utils/global.dart';
import 'package:rando/utils/theme/theme.dart';

class ActivityWidget extends StatefulWidget {
  final ItemData item;
  const ActivityWidget({super.key, required this.item});

  @override
  State<ActivityWidget> createState() => _ActivityWidgetState();
}

class _ActivityWidgetState extends State<ActivityWidget> {
  var user = AuthService().user!;
  UserService userService = UserService();
  ItemService itemService = ItemService();
  bool isLiked = false;
  String username = '';
  bool isOwner = false;
  String likedBoardID = '';

  @override
  void initState() {
    super.initState();
    checkLiked();
    checkAuth();
    getUsername();
    getLikedBoard();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getLikedBoard() async {
    UserData data = await userService.getUserData(user.uid);
    setState(() {
      likedBoardID = data.likedItemsBoardID;
    });
  }

  Future<void> checkAuth() async {
    if (mounted) setState(() => isOwner = (user.uid == widget.item.uid));
  }

  Future<void> checkLiked() async {
    bool liked = await userService.userLikesItem(user.uid, widget.item.id);
    if (mounted) setState(() => isLiked = liked);
  }

  Future<void> getUsername() async {
    String name = await userService.getUsername(widget.item.uid);
    if (mounted) setState(() => username = name);
  }

  void toggleLike() {
    if (mounted) setState(() => isLiked = !isLiked);
    itemService.updateItemLikes(
      user.uid,
      widget.item.id,
      likedBoardID,
      isLiked,
    );
  }

  Stream<ItemData> getItemDataStream() {
    return itemService.getItemStream(widget.item.id);
  }

  @override
  Widget build(BuildContext context) {
    double spacing = 15;
    return StreamBuilder<ItemData>(
      stream: getItemDataStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("Item Not Found."));
        }

        ItemData itemData = snapshot.data!;
        return Center(
          child: BlockWidget(
            inverted: false,
            horizontal: null,
            vertical: null,
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
                    ActivityMenuButton(
                      itemID: itemData.id,
                      userID: user.uid,
                      isOwner: isOwner,
                      imgURL: itemData.imgURL,
                    ),
                  ],
                ),
                SizedBox(height: spacing),
                ImageWidget(
                  borderRadius: borderRadius,
                  imgURL: itemData.imgURL,
                  height: 256,
                  width: double.infinity,
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
        );
      },
    );
  }
}
