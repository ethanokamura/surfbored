// dart packages
import 'dart:typed_data';
import 'package:flutter/material.dart';

// utils
import 'package:rando/services/storage.dart';
import 'package:rando/utils/default_image_config.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({super.key});

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  // variables
  StorageService storage = StorageService();
  Uint8List? pickedImage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getProfilePicture();
  }

  Future<void> getProfilePicture() async {
    try {
      final imageBytes = await storage.getFile('profile.png');
      setState(() {
        pickedImage = imageBytes;
        isLoading = false;
      });
    } catch (e) {
      print('could not get profile picture: $e');
      final imageBytes =
          storage.ref.child('default/${DefaultImageConfig().profileIMG}');
      Uint8List? imageRef = await imageBytes.getData();
      setState(() {
        pickedImage = imageRef;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      width: 128,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
        image: pickedImage != null
            ? DecorationImage(
                fit: BoxFit.cover,
                image: Image.memory(
                  pickedImage!,
                  fit: BoxFit.cover,
                ).image,
              )
            : null,
      ),
      child: Center(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : pickedImage == null
                ? const Center(
                    child: Icon(
                      Icons.person_rounded,
                      size: 35,
                    ),
                  )
                : null,
      ),
    );
  }
}
