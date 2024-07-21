// dart packages
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:rando/shared/images/image.dart';

// utils
import 'package:rando/config/global.dart';
import 'package:rando/core/utils/methods.dart';
import 'package:rando/core/services/storage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:rando/core/services/firestore.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

// components
// import 'package:rando/components/images/image.dart';
import 'package:rando/shared/widgets/buttons/icon_button.dart';

// ui
import 'package:rando/config/theme.dart';

class EditImage extends StatefulWidget {
  final String? imgURL;
  final String docID;
  final String collection;
  final double height;
  final double width;
  final Function(String url) onFileChanged;
  const EditImage({
    super.key,
    required this.width,
    required this.height,
    required this.docID,
    required this.collection,
    required this.imgURL,
    required this.onFileChanged,
  });

  @override
  State<EditImage> createState() => _EditImageState();
}

class _EditImageState extends State<EditImage> {
  // variables
  StorageService storage = StorageService();
  FirestoreService firestoreService = FirestoreService();
  final ImagePicker picker = ImagePicker();

  Uint8List? pickedImage;
  String? imageURL;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getImageURL(widget.imgURL);
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

      print("in edit screen, $filename has been compressed");

      // failed compression
      if (compressedImage == null) throw Exception("Image compression failed");

      // get path
      String path = '${widget.collection}/${widget.docID}/$filename';

      print("in edit screen, uploading compressed image at path $path");

      // upload image
      final uploadURL = await firestoreService.uploadImage(
        compressedImage,
        path,
        widget.collection,
        widget.docID,
      );

      if (uploadURL == null) throw Exception("error uploading");

      // set state
      setState(() {
        imageURL = uploadURL;
        pickedImage = compressedImage.readAsBytesSync();
        isLoading = false;
      });

      // return new fileURL
      widget.onFileChanged(uploadURL);
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

  Future<File?> compressImage(File file) async {
    // get path
    final filePath = file.absolute.path;
    final lastIndex = filePath.lastIndexOf('.');
    final outPath = '${filePath.substring(0, lastIndex)}_compressed.jpg';
    // get result
    try {
      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        outPath,
        quality: 70,
      );
      // return result
      if (result != null) return File(result.path);
      print('compression failed: result is null');
      return null;
    } catch (e) {
      print("compression error: $e");
      return null;
    }
  }

  @override
  void dispose() {
    storage.cancelOperation();
    super.dispose();
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
