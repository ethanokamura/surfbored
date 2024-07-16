// dart packages
import 'dart:typed_data';
import 'package:flutter/material.dart';

// utils
import 'package:rando/services/auth.dart';
import 'package:rando/services/firestore/firestore.dart';
import 'package:rando/services/storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rando/utils/global.dart';

// ui
import 'package:rando/utils/theme/theme.dart';

class EditProfilePicture extends StatefulWidget {
  final String imgURL;
  final double height;
  final double width;
  const EditProfilePicture({
    super.key,
    required this.imgURL,
    required this.height,
    required this.width,
  });

  @override
  State<EditProfilePicture> createState() => _EditProfilePictureState();
}

class _EditProfilePictureState extends State<EditProfilePicture> {
  // variables
  StorageService storage = StorageService();
  FirestoreService firestoreService = FirestoreService();
  Uint8List? pickedImage;
  bool isLoading = false;

  var user = AuthService().user!;

  @override
  void initState() {
    super.initState();
    getImage();
  }

  Future<void> onProfileTapped() async {
    final ImagePicker picker = ImagePicker();
    try {
      // get image
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      // check mount before setting state
      if (image == null || !mounted) return;
      setState(() {
        isLoading = true;
      });

      // convert image
      final imageBytes = await image.readAsBytes();

      firestoreService.setPhotoURL('users', user.uid, 'profile.png');
      await storage.uploadFile('users/${user.uid}/profile.png', imageBytes);
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

  Future<void> getImage() async {
    if (widget.imgURL == '') {
      setState(() {
        pickedImage = null;
        isLoading = false;
      });
    } else {
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
  }

  @override
  void dispose() {
    storage.cancelOperation(); // Example: Cancel any ongoing storage operations
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onProfileTapped,
      child: Container(
        height: widget.height,
        width: widget.width,
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
                  ? Center(
                      child: Container(
                        height: widget.height,
                        width: widget.width,
                        decoration: BoxDecoration(
                          borderRadius: borderRadius,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Center(
                          child: Container(
                            height: widget.height / 2,
                            width: widget.width / 2,
                            decoration: BoxDecoration(
                              borderRadius: borderRadius,
                              image: DecorationImage(
                                image: AssetImage(
                                    Theme.of(context).defaultImagePath),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : null,
        ),
      ),
    );
  }
}
