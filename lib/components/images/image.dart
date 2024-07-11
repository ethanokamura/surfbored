// dart packages
import 'dart:typed_data';
import 'package:flutter/material.dart';

// utils
import 'package:rando/services/storage.dart';
import 'package:rando/utils/theme/theme.dart';

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
                ? Center(
                    child: Container(
                      height: widget.height,
                      width: widget.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).backgroundColor,
                      ),
                      child: Center(
                        child: Container(
                          height: widget.height / 2,
                          width: widget.width / 2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: const DecorationImage(
                              image: AssetImage(
                                  'assets/images/localsonly_face.png'),
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
