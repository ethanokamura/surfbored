// dart packages
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:rando/components/images/image.dart';
// import 'package:rando/components/images/image.dart';

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
  final Function(File file, String filename) onFileChanged;
  final String? imgURL;
  final double height;
  final double width;
  const UploadImageWidget({
    super.key,
    required this.imgURL,
    required this.height,
    required this.width,
    required this.onFileChanged,
  });

  @override
  State<UploadImageWidget> createState() => _UploadImageWidgetState();
}

class _UploadImageWidgetState extends State<UploadImageWidget> {
  // variables
  StorageService storage = StorageService();
  final ImagePicker picker = ImagePicker();
  Uint8List? pickedImage;
  String? imageURL;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getImageURL(widget.imgURL);
  }

  @override
  void dispose() {
    storage.cancelOperation();
    super.dispose();
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
            const SizedBox(width: 40),
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

  Future pickImage(ImageSource source) async {
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

      // get original filename
      final filename = pickedFile.path.split('/').last;

      // crop file
      var croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      );
      if (croppedFile == null) return;

      // compress image
      final compressedImage = await compressImage(File(croppedFile.path));

      // failed compression
      // if (compressedImage == null) throw Exception("Image compression failed");

      // check mount before setting state
      if (!mounted) return;
      setState(() {
        pickedImage = compressedImage.readAsBytesSync();
        isLoading = false;
      });

      // return image bytes
      widget.onFileChanged(compressedImage, filename);
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

  Future<File> compressImage(File file) async {
    // get path
    final filePath = file.absolute.path;
    final lastIndex = filePath.lastIndexOf('.');
    final outPath = '${filePath.substring(0, lastIndex)}_compressed.jpg';
    // get result
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: 70,
    );
    // return result
    return File(result!.path);
  }

  Future<void> getImageURL(String? path) async {
    if (path == null) {
      setState(() {
        imageURL = null;
      });
    } else {
      if (path.isNotEmpty) {
        try {
          setState(() {
            imageURL = path;
          });
        } catch (e) {
          setState(() {
            imageURL = null;
          });
        }
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: selectPhoto,
      child: ImageWidget(
        height: widget.height,
        width: widget.width,
        imgURL: imageURL,
        borderRadius: borderRadius,
      ),
    );
  }
}
