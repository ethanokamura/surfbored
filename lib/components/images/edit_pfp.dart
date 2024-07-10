// dart packages
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:rando/services/auth.dart';
import 'package:rando/services/firestore.dart';

// utils
import 'package:rando/services/storage.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePicture extends StatefulWidget {
  final String imgURL;
  const EditProfilePicture({super.key, required this.imgURL});

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
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (image == null) return;
      final imageBytes = await image.readAsBytes();
      firestoreService.setUserPhotoURL(user!.uid, 'profile.png');
      await storage.uploadFile('users/${user!.uid}/profile.png', imageBytes);
      setState(() {
        pickedImage = imageBytes;
        isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to pick image. Please try again."),
          ),
        );
      }
    }
  }

  Future<void> getProfilePicture() async {
    try {
      final imageBytes = await storage.getFile(widget.imgURL);
      setState(() {
        pickedImage = imageBytes;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        pickedImage = null;
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
