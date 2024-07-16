// dart packages
import 'dart:typed_data';
import 'package:flutter/material.dart';

// utils
import 'package:rando/services/storage.dart';
import 'package:rando/utils/global.dart';

// ui
import 'package:rando/utils/theme/theme.dart';

class CircleImageWidget extends StatefulWidget {
  final String imgURL;
  final double height;
  final double width;
  const CircleImageWidget({
    super.key,
    required this.imgURL,
    required this.height,
    required this.width,
  });

  @override
  State<CircleImageWidget> createState() => _CircleImageWidgetState();
}

class _CircleImageWidgetState extends State<CircleImageWidget> {
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
    if (widget.imgURL == '') {
      if (mounted) {
        setState(() {
          pickedImage = null;
          isLoading = false;
        });
      }
    } else {
      try {
        final Uint8List? imageBytes = await storage.getFile(widget.imgURL);
        if (mounted) {
          setState(() {
            pickedImage = imageBytes;
            isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            pickedImage = null;
            isLoading = false;
          });
        }
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
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
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
                          height: widget.height / 4,
                          width: widget.width / 4,
                          decoration: BoxDecoration(
                            borderRadius: borderRadius,
                            image: DecorationImage(
                              image: AssetImage(
                                Theme.of(context).defaultImagePath,
                              ),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : null,
      ),
    );
  }
}
