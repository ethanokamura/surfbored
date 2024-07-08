// dart packages
import 'dart:typed_data';
import 'package:flutter/material.dart';

// utils
import 'package:rando/services/storage.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePicture extends StatefulWidget {
  const EditProfilePicture({super.key});

  @override
  State<EditProfilePicture> createState() => _EditProfilePictureState();
}

class _EditProfilePictureState extends State<EditProfilePicture> {
  // variables
  StorageService storage = StorageService();
  Uint8List? pickedImage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getProfilePicture();
  }

  Future<void> onProfileTapped() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    await storage.uploadFile('profile.png', image);
    final imageBytes = await image.readAsBytes();
    setState(() {
      pickedImage = imageBytes;
      isLoading = false;
    });
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
      final imageBytes = await storage.ref.child('default/profile.png');
      Uint8List? imageRef = await imageBytes.getData();
      setState(() {
        pickedImage = imageRef;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onProfileTapped,
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
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
      ),
    );
  }
}
