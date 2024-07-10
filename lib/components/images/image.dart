// dart packages
import 'dart:typed_data';
import 'package:flutter/material.dart';

// utils
import 'package:rando/services/storage.dart';

class ImageWidget extends StatefulWidget {
  final String imgURL;
  final double height;
  final double width;
  const ImageWidget({
    super.key,
    required this.imgURL,
    required this.height,
    required this.width,
  });

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  // variables
  StorageService storage = StorageService();
  Uint8List? pickedImage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getImage();
  }

  Future<void> getImage() async {
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
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
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
                      Icons.question_mark,
                      size: 35,
                    ),
                  )
                : null,
      ),
    );
  }
}
