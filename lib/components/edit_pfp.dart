// dart packages
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:rando/services/auth.dart';
import 'package:rando/services/firestore.dart';

// utils
import 'package:rando/services/storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rando/utils/default_image_config.dart';

class EditProfilePicture extends StatefulWidget {
  final String profilePicturePath;
  const EditProfilePicture({super.key, required this.profilePicturePath});

  @override
  State<EditProfilePicture> createState() => _EditProfilePictureState();
}

class _EditProfilePictureState extends State<EditProfilePicture> {
  // variables
  StorageService storage = StorageService();
  FirestoreService firestoreService = FirestoreService();
  Uint8List? pickedImage;
  bool isLoading = true;

  var user = AuthService().user;

  @override
  void initState() {
    super.initState();
    getProfilePicture();
  }

  Future<void> onProfileTapped() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    await storage.uploadFile('users/${user!.uid}/profile.png', image);
    firestoreService.setUserPhotoPath(user!.uid, 'profile.png');
    final imageBytes = await image.readAsBytes();
    setState(() {
      pickedImage = imageBytes;
      isLoading = false;
    });
  }

  Future<void> getProfilePicture() async {
    try {
      print("profilePicturePath: ${widget.profilePicturePath}");
      final imageBytes = await storage.getFile(widget.profilePicturePath);
      setState(() {
        pickedImage = imageBytes;
        isLoading = false;
      });
    } catch (e) {
      print("could not find image $e");
      final imageBytes = await storage.getFile(DefaultImageConfig().profileIMG);
      setState(() {
        pickedImage = imageBytes;
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
