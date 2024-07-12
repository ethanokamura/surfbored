import 'package:flutter/material.dart';
import 'package:rando/components/buttons/like_button.dart';
import 'package:rando/components/containers/tag_list.dart';
import 'package:rando/services/auth.dart';
import 'package:rando/services/firestore/item_service.dart';
import 'package:rando/services/models.dart';
import 'package:rando/components/images/image.dart';
import 'package:rando/services/firestore/user_service.dart';
import 'package:rando/utils/theme/theme.dart';

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

  // use statefull widget to check auth and add the ability to edit stuff
  Future<bool> checkAuth() async {
    var user = auth.user!;
    return user.uid == widget.item.uid;
  }

  Future<bool> checkLiked() async {
    var user = auth.user!;
    isLiked = await userService.userLikesItem(user.uid, widget.item.id);
    return isLiked;
  }

  @override
  void initState() {
    super.initState();
    checkLiked();
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Material(
            elevation: 15,
            color: Theme.of(context).colorScheme.surface,
            shadowColor: Theme.of(context).shadowColor,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ImageWidget(
                    imgURL: widget.item.imgURL,
                    width: 256,
                    height: 256,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.item.title,
                    style: TextStyle(
                      color: Theme.of(context).textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    widget.item.description,
                    style: TextStyle(
                      color: Theme.of(context).subtextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TagListWidget(tags: widget.item.tags),
                  Row(
                    children: [
                      LikeButton(isLiked: isLiked, onTap: toggleLike),
                      const SizedBox(width: 10),
                      Text("${widget.item.likes} likes"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
