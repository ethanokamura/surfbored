import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rando/components/buttons/like_button.dart';
import 'package:rando/components/buttons/activity_menu.dart';
import 'package:rando/components/block.dart';
import 'package:rando/components/lists/tag_list.dart';
import 'package:rando/components/buttons/link.dart';
import 'package:rando/pages/profile/profile.dart';
import 'package:rando/utils/data/firestore/auth_service.dart';
import 'package:rando/utils/data/firestore/item_service.dart';
import 'package:rando/utils/data/models.dart';
import 'package:rando/components/images/image.dart';
import 'package:rando/utils/data/firestore/user_service.dart';
import 'package:rando/utils/global.dart';
import 'package:rando/utils/theme/theme.dart';

class ActivityWidget extends StatefulWidget {
  final ItemData item;
  const ActivityWidget({super.key, required this.item});

  @override
  State<ActivityWidget> createState() => _ActivityWidgetState();
}

class _ActivityWidgetState extends State<ActivityWidget> {
  late UserService userService;
  late ItemService itemService;
  late User user;
  bool isLiked = false;
  String username = '';
  bool isOwner = false;
  String likedBoardID = '';

  @override
  void initState() {
    super.initState();
    userService = UserService();
    itemService = ItemService();
    user = AuthService().user!;
    checkLiked();
    checkAuth();
    getUsername();
    getLikedBoard();
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
    bool liked = await userService.hasUserLikedItem(user.uid, widget.item.id);
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

  @override
  Widget build(BuildContext context) {
    double spacing = 15;

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
                  widget.item.title,
                  style: TextStyle(
                    color: Theme.of(context).textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                ActivityMenuButton(
                  itemID: widget.item.id,
                  userID: user.uid,
                  isOwner: isOwner,
                  imgURL: widget.item.imgURL,
                  onDelete: () => Navigator.pop(context),
                ),
              ],
            ),
            SizedBox(height: spacing),
            Hero(
              tag: widget.item.imgURL,
              child: ImageWidget(
                borderRadius: borderRadius,
                imgURL: widget.item.imgURL,
                height: 256,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.item.description,
              style: TextStyle(
                color: Theme.of(context).subtextColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: spacing),
            TagListWidget(tags: widget.item.tags),
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
                          ProfileScreen(userID: widget.item.uid),
                    ),
                  ),
                  text: '@$username',
                ),
                StreamBuilder<int>(
                  stream: itemService.getLikesStream('items', widget.item.id),
                  builder: (context, snapshot) {
                    int likes = snapshot.data ?? widget.item.likes;
                    return LikeButton(
                      likes: likes,
                      isLiked: isLiked,
                      onTap: toggleLike,
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
