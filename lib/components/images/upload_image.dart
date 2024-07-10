// dart packages
import 'dart:typed_data';
import 'package:flutter/material.dart';

// utils
import 'package:rando/services/storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rando/utils/default_image_config.dart';

// ui
// import 'package:rando/utils/theme/theme.dart';

class UploadImageWidget extends StatefulWidget {
  final Function(Uint8List imageBytes) onImagePicked;

  const UploadImageWidget({required this.onImagePicked, super.key});

  @override
  State<UploadImageWidget> createState() => _UploadImageWidgetState();
}

class _UploadImageWidgetState extends State<UploadImageWidget> {
  // variables
  StorageService storage = StorageService();
  Uint8List? pickedImage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getImage();
  }

  Future<void> onImageTapped() async {
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

      // check mount before setting state
      if (!mounted) return;
      setState(() {
        pickedImage = imageBytes;
        isLoading = false;
      });

      // return image bytes
      widget.onImagePicked(imageBytes);
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
    try {
      final imageBytes = await storage.getFile(DefaultImageConfig().profileIMG);
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
    return Column(
      children: [
        GestureDetector(
          onTap: onImageTapped,
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
        ),
        const SizedBox(height: 20),
        const Center(
          child: Text("(Tap my face to upload a picture!)"),
        ),
      ],
    );
  }
}
