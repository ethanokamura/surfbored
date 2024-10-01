// dart packages
import 'dart:io';
import 'dart:typed_data';
import 'package:api_client/api_client.dart';
import 'package:app_ui/src/buttons.dart';
import 'package:app_ui/src/constants.dart';
import 'package:app_ui/src/extensions.dart';
import 'package:app_ui/src/icons.dart';
import 'package:app_ui/src/pop_ups.dart';
import 'package:app_ui/src/text.dart';
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
    required this.docID,
    required this.collection,
    required this.photoUrl,
    required this.onFileChanged,
    super.key,
  });

  final String? photoUrl;
  final String docID;
  final String collection;
  final double width;
  final dynamic Function(String url) onFileChanged;

  @override
  State<EditImage> createState() => _EditImageState();
}

class _EditImageState extends State<EditImage> {
  final ImagePicker picker = ImagePicker();
  Uint8List? pickedImage;
  String? photoUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getImageURL(widget.photoUrl);
  }

  Future<void> getImageURL(String? path) async {
    if (path == null) {
      setState(() {
        photoUrl = null;
      });
    } else {
      if (path.isNotEmpty) {
        try {
          setState(() {
            photoUrl = path;
          });
        } catch (e) {
          setState(() {
            photoUrl = null;
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
        const TitleText(text: '${AppStrings.selectMedia}:', fontSize: 24),
        const VerticalSpacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ActionSelectButton(
              icon: AppIcons.camera,
              label: AppStrings.camera,
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.camera);
              },
            ),
            const SizedBox(width: 40),
            ActionSelectButton(
              icon: AppIcons.posts,
              label: AppStrings.photoLibrary,
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

      // crop file
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),
      );

      if (croppedFile == null) return;

      // compress image
      final compressedImage = await compressImage(File(croppedFile.path));

      // failed compression
      if (compressedImage == null) throw Exception('Image compression failed');

      setState(() {
        pickedImage = compressedImage.readAsBytesSync();
      });

      if (pickedImage == null) return;

      // upload image
      final uploadURL = await Supabase.instance.client.uploadFile(
        widget.collection,
        widget.docID,
        pickedImage!,
      );

      // set state
      setState(() {
        photoUrl = uploadURL;
        isLoading = false;
      });

      // return new fileURL
      widget.onFileChanged(uploadURL);
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        context.showSnackBar('Failed to pick image. Please try again.');
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
        width: widget.width,
        photoUrl: photoUrl,
        borderRadius: defaultBorderRadius,
      ),
    );
  }
}

class UploadImageWidget extends StatefulWidget {
  const UploadImageWidget({
    required this.photoUrl,
    required this.width,
    required this.onFileChanged,
    super.key,
  });

  final dynamic Function(File file) onFileChanged;
  final String? photoUrl;
  final double width;

  @override
  State<UploadImageWidget> createState() => _UploadImageWidgetState();
}

class _UploadImageWidgetState extends State<UploadImageWidget> {
  // variables
  final ImagePicker picker = ImagePicker();
  Uint8List? pickedImage;
  String? photoUrl;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getImageURL(widget.photoUrl);
  }

  Future<void> selectPhoto() async {
    await showBottomModal(
      context,
      <Widget>[
        const TitleText(text: '${AppStrings.selectMedia}:', fontSize: 24),
        const VerticalSpacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ActionSelectButton(
              icon: AppIcons.camera,
              label: AppStrings.camera,
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.camera);
              },
            ),
            const SizedBox(width: 40),
            ActionSelectButton(
              icon: AppIcons.posts,
              label: AppStrings.photoLibrary,
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

      // crop file
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),
      );
      if (croppedFile == null) return;

      // compress image
      final compressedImage = await compressImage(File(croppedFile.path));

      // check mount before setting state
      if (!mounted) return;
      setState(() {
        pickedImage = compressedImage.readAsBytesSync();
        isLoading = false;
      });

      // return image bytes
      widget.onFileChanged(compressedImage);
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        context.showSnackBar('Failed to pick image. Please try again.');
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
        photoUrl = null;
      });
    } else {
      if (path.isNotEmpty) {
        try {
          setState(() {
            photoUrl = path;
          });
        } catch (e) {
          setState(() {
            photoUrl = null;
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
              width: widget.width,
              photoUrl: photoUrl,
              borderRadius: defaultBorderRadius,
            ),
    );
  }
}

class ImageWidget extends StatefulWidget {
  const ImageWidget({
    required this.borderRadius,
    required this.photoUrl,
    required this.width,
    super.key,
  });

  final String? photoUrl;
  final double width;
  final BorderRadius borderRadius;

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  String? photoUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getImageURL(widget.photoUrl);
  }

  // invoked when the parent widget rebuilds
  // passes a new instance of the widget to the existing state object
  @override
  void didUpdateWidget(covariant ImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.photoUrl != widget.photoUrl) {
      getImageURL(widget.photoUrl);
    }
  }

  Future<void> getImageURL(String? path) async {
    if (path == null) {
      setState(() {
        photoUrl = null;
      });
    } else {
      if (path.isNotEmpty) {
        try {
          setState(() {
            photoUrl = path;
          });
        } catch (e) {
          setState(() {
            photoUrl = null;
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
        : photoUrl != null
            ? imageWidget(photoUrl!)
            : errorWidget(context);
  }

  Widget loadingWidget(BuildContext context) {
    return Container(
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius,
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget errorWidget(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        width: widget.width,
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Center(
          child: Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
              image: DecorationImage(
                image: AssetImage(Theme.of(context).defaultImagePath),
                fit: BoxFit.contain,
              ),
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
      imageBuilder: (context, imageProvider) => AspectRatio(
        aspectRatio: 4 / 3,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: widget.borderRadius,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: imageProvider,
            ),
          ),
        ),
      ),
    );
  }
}

class EditSquareImage extends StatefulWidget {
  const EditSquareImage({
    required this.width,
    required this.height,
    required this.docID,
    required this.collection,
    required this.photoUrl,
    required this.onFileChanged,
    super.key,
  });

  final String? photoUrl;
  final String docID;
  final String collection;
  final double width;
  final double height;
  final dynamic Function(String url) onFileChanged;

  @override
  State<EditSquareImage> createState() => _EditSquareImageState();
}

class _EditSquareImageState extends State<EditSquareImage> {
  final ImagePicker picker = ImagePicker();
  Uint8List? pickedImage;
  String? photoUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getImageURL(widget.photoUrl);
  }

  Future<void> getImageURL(String? path) async {
    if (path == null) {
      setState(() {
        photoUrl = null;
      });
    } else {
      if (path.isNotEmpty) {
        try {
          setState(() {
            photoUrl = path;
          });
        } catch (e) {
          setState(() {
            photoUrl = null;
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
        const TitleText(text: '${AppStrings.selectMedia}:', fontSize: 24),
        const VerticalSpacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ActionSelectButton(
              icon: AppIcons.camera,
              label: AppStrings.camera,
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.camera);
              },
            ),
            const SizedBox(width: 40),
            ActionSelectButton(
              icon: AppIcons.posts,
              label: AppStrings.photoLibrary,
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

      setState(() {
        pickedImage = compressedImage.readAsBytesSync();
      });

      if (pickedImage == null) return;

      // upload image
      final uploadURL = await Supabase.instance.client.uploadFile(
        widget.collection,
        widget.docID,
        pickedImage!,
      );

      // set state
      setState(() {
        photoUrl = uploadURL;
        isLoading = false;
      });

      // return new fileURL
      widget.onFileChanged(uploadURL);
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        context.showSnackBar('Failed to pick image. Please try again.');
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
      child: SquareImage(
        width: widget.width,
        height: widget.height,
        photoUrl: photoUrl,
        borderRadius: defaultBorderRadius,
      ),
    );
  }
}

class SquareImage extends StatefulWidget {
  const SquareImage({
    required this.borderRadius,
    required this.photoUrl,
    required this.width,
    required this.height,
    super.key,
  });

  final String? photoUrl;
  final double width;
  final double height;
  final BorderRadius borderRadius;

  @override
  State<SquareImage> createState() => _SquareImageWidgetState();
}

class _SquareImageWidgetState extends State<SquareImage> {
  String? photoUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getImageURL(widget.photoUrl);
  }

  // invoked when the parent widget rebuilds
  // passes a new instance of the widget to the existing state object
  @override
  void didUpdateWidget(covariant SquareImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.photoUrl != widget.photoUrl) {
      getImageURL(widget.photoUrl);
    }
  }

  Future<void> getImageURL(String? path) async {
    if (path == null) {
      setState(() {
        photoUrl = null;
      });
    } else {
      if (path.isNotEmpty) {
        try {
          setState(() {
            photoUrl = path;
          });
        } catch (e) {
          setState(() {
            photoUrl = null;
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
        : photoUrl != null
            ? imageWidget(photoUrl!)
            : errorWidget(context);
  }

  Widget loadingWidget(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
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
          height: widget.height,
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
