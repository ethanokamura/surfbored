// dart packages
import 'dart:io';
import 'dart:typed_data';
import 'package:api_client/api_client.dart';
import 'package:app_ui/src/buttons.dart';
import 'package:app_ui/src/constants.dart';
import 'package:app_ui/src/pop_ups.dart';
import 'package:app_ui/src/theme.dart';
import 'package:app_ui/src/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class EditImage extends StatefulWidget {
  const EditImage({
    required this.width,
    required this.height,
    required this.docID,
    required this.collection,
    required this.photoURL,
    required this.onFileChanged,
    super.key,
  });

  final String? photoURL;
  final String docID;
  final String collection;
  final double height;
  final double width;
  final dynamic Function(String url) onFileChanged;

  @override
  State<EditImage> createState() => _EditImageState();
}

class _EditImageState extends State<EditImage> {
  final ImagePicker picker = ImagePicker();
  Uint8List? pickedImage;
  String? imageURL;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getImageURL(widget.photoURL);
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

  Future<void> selectPhoto() async {
    await showBottomModal(
      context,
      <Widget>[
        Text(
          'Select Media:',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const VerticalSpacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ActionIconButton(
              icon: Icons.camera_alt_outlined,
              label: 'Camera',
              inverted: true,
              size: 40,
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.camera);
              },
            ),
            const SizedBox(width: 40),
            ActionIconButton(
              icon: Icons.photo_library_outlined,
              label: 'Library',
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
    try {
      // compress image
      final pickedFile = await picker.pickImage(
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
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      );

      if (croppedFile == null) return;

      // compress image
      final compressedImage = await compressImage(File(croppedFile.path));

      // failed compression
      if (compressedImage == null) throw Exception('Image compression failed');

      // get path
      final path = '${widget.collection}/${widget.docID}/$filename';

      // upload image
      final uploadURL = await FirebaseStorage.instance.uploadFile(
        path,
        compressedImage,
      );

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
            content: Text('Failed to pick image. Please try again.'),
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
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: selectPhoto,
      child: ImageWidget(
        height: widget.height,
        width: widget.width,
        photoURL: imageURL,
        borderRadius: defaultBorderRadius,
      ),
    );
  }
}

class UploadImageWidget extends StatefulWidget {
  const UploadImageWidget({
    required this.imgURL,
    required this.height,
    required this.width,
    required this.onFileChanged,
    super.key,
  });

  final dynamic Function(File file, String filename) onFileChanged;
  final String? imgURL;
  final double height;
  final double width;

  @override
  State<UploadImageWidget> createState() => _UploadImageWidgetState();
}

class _UploadImageWidgetState extends State<UploadImageWidget> {
  // variables
  final ImagePicker picker = ImagePicker();
  Uint8List? pickedImage;
  String? imageURL;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getImageURL(widget.imgURL);
  }

  Future<void> selectPhoto() async {
    await showBottomModal(
      context,
      <Widget>[
        Text(
          'Select Media:',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const VerticalSpacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ActionIconButton(
              icon: Icons.camera_alt_outlined,
              label: 'Camera',
              inverted: true,
              size: 40,
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.camera);
              },
            ),
            const SizedBox(width: 40),
            ActionIconButton(
              icon: Icons.photo_library_outlined,
              label: 'Library',
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
    try {
      // compress image
      final pickedFile = await picker.pickImage(
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
      final croppedFile = await ImageCropper().cropImage(
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
            content: Text('Failed to pick image. Please try again.'),
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
      child: pickedImage != null
          ? Image.memory(pickedImage!)
          : ImageWidget(
              height: widget.height,
              width: widget.width,
              photoURL: imageURL,
              borderRadius: defaultBorderRadius,
            ),
    );
  }
}

class ImageWidget extends StatefulWidget {
  const ImageWidget({
    required this.borderRadius,
    required this.photoURL,
    required this.height,
    required this.width,
    super.key,
  });

  final String? photoURL;
  final double height;
  final double width;
  final BorderRadius borderRadius;

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  String? imageURL;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getImageURL(widget.photoURL);
  }

  // invoked when the parent widget rebuilds
  // passes a new instance of the widget to the existing state object
  @override
  void didUpdateWidget(covariant ImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.photoURL != widget.photoURL) {
      getImageURL(widget.photoURL);
    }
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
    return isLoading
        ? loadingWidget(context)
        : imageURL != null
            ? imageWidget(imageURL!)
            : errorWidget(context);
  }

  Widget loadingWidget(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius,
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget errorWidget(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius,
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Center(
        child: Container(
          height: widget.height / 4,
          width: widget.width == double.infinity ? 64 : widget.width / 4,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            image: DecorationImage(
              image: AssetImage(Theme.of(context).defaultImagePath),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

  Widget imageWidget(String data) {
    return CachedNetworkImage(
      imageUrl: data,
      placeholder: (context, url) => loadingWidget(context),
      errorWidget: (context, url, error) => errorWidget(context),
      imageBuilder: (context, imageProvider) => Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: widget.borderRadius,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: imageProvider,
          ),
        ),
      ),
    );
  }
}
