// dart packages
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// utils
import 'package:rando/services/storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rando/utils/global.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:rando/utils/methods.dart';

// components
import 'package:rando/components/buttons/icon_button.dart';

// ui
import 'package:rando/utils/theme/theme.dart';

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

  Future selectPhoto() async {
    await showBottomModal(
      context,
      <Widget>[
        Text(
          "Select Media:",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            CustomIconButton(
              icon: Icons.camera_alt_outlined,
              label: "Camera",
              inverted: true,
              size: 40,
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.camera);
              },
            ),
            const SizedBox(width: 20),
            CustomIconButton(
              icon: Icons.photo_library_outlined,
              label: "Library",
              inverted: true,
              size: 40,
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ],
    );
  }

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    try {
      // compress image
      final XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 50,
      );

      // error picking file
      if (pickedFile == null || !mounted) return;

      // loading
      setState(() {
        isLoading = true;
      });

      // crop file
      var file = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      );
      if (file == null) return;

      // convert image
      final imageBytes = await file.readAsBytes();

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
          onTap: selectPhoto,
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
        ),
        const SizedBox(height: 20),
        pickedImage == null
            ? const Center(
                child: Text("(Tap my face to upload a picture!)"),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
