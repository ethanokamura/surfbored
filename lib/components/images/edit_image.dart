// dart packages
import 'dart:typed_data';
import 'package:flutter/material.dart';

// utils
import 'package:rando/services/firestore/firestore.dart';
import 'package:rando/services/storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rando/utils/global.dart';

// ui
import 'package:rando/utils/theme/theme.dart';

class EditImage extends StatefulWidget {
  final String imgURL;
  final String docID;
  final String collection;
  final double height;
  final double width;
  const EditImage({
    super.key,
    required this.width,
    required this.height,
    required this.docID,
    required this.collection,
    required this.imgURL,
  });

  @override
  State<EditImage> createState() => _EditImageState();
}

class _EditImageState extends State<EditImage> {
  // variables
  StorageService storage = StorageService();
  FirestoreService firestoreService = FirestoreService();
  Uint8List? pickedImage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getImage();
  }

  Future<void> onTap() async {
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

      firestoreService.setPhotoURL(
        widget.collection,
        widget.docID,
        'coverImage.png',
      );
      await storage.uploadFile(
        '${widget.collection}/${widget.docID}/coverImage.png',
        imageBytes,
      );
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
      onTap: onTap,
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          image: pickedImage != null
              ? DecorationImage(
                  fit: BoxFit.cover,
                  image: MemoryImage(pickedImage!),
                )
              : null,
        ),
        child: Center(
          child: isLoading
              ? loadingWidget(context)
              : pickedImage == null
                  ? errorWidget(context)
                  : null,
        ),
      ),
    );
  }

  Widget loadingWidget(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: Theme.of(context).colorScheme.primary,
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget errorWidget(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Center(
        child: Container(
          height: widget.height / 4,
          width: widget.width == double.infinity ? 64 : widget.width / 4,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            image: DecorationImage(
              image: AssetImage(Theme.of(context).defaultImagePath),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
