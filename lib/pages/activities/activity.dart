import 'package:flutter/material.dart';
import 'package:rando/components/containers/tag_list.dart';
import 'package:rando/services/auth.dart';
import 'package:rando/services/models.dart';
import 'package:rando/components/images/image.dart';
import 'package:rando/utils/default_image_config.dart';
import 'package:rando/utils/theme/theme.dart';

class ActivityScreen extends StatelessWidget {
  final Item item;
  ActivityScreen({super.key, required this.item});

  final auth = AuthService();

  // use statefull widget to check auth and add the ability to edit stuff
  Future<bool> checkAuth() async {
    var user = auth.user!;
    return user.uid == item.uid;
  }

  String getPhotoURL(String photoURL) {
    return (photoURL == '') ? DefaultImageConfig().profileIMG : photoURL;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
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
                    imgURL: getPhotoURL(item.imgURL),
                    width: 256,
                    height: 256,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    item.title,
                    style: TextStyle(
                      color: Theme.of(context).textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    item.description,
                    style: TextStyle(
                      color: Theme.of(context).subtextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TagListWidget(tags: item.tags),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
