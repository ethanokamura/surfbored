// dart packages
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// utils
import 'package:rando/services/storage.dart';
import 'package:image_picker/image_picker.dart';

// ui
// import 'package:rando/utils/theme/theme.dart';

class UploadImageWidget extends StatefulWidget {
  final Function(Uint8List imageBytes) onImagePicked;
  final String imgURL;
  final double height;
  final double width;
  const UploadImageWidget({
    super.key,
    required this.imgURL,
    required this.height,
    required this.width,
    required this.onImagePicked,
  });

  @override
  State<UploadImageWidget> createState() => _UploadImageWidgetState();
}

class _UploadImageWidgetState extends State<UploadImageWidget> {
  // variables
  StorageService storage = StorageService();
  Uint8List? pickedImage;
  bool isLoading = false;

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
                      ? Center(
                          child: Container(
                            height: 128,
                            width: 128,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: const DecorationImage(
                                image: AssetImage(
                                    'assets/images/localsonly_face.png'),
                                fit: BoxFit.contain,
                              ),
                            ),
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
