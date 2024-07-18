// dart packages
// import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:rando/components/buttons/icon_button.dart';
// import 'package:path/path.dart' as p;
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:image/image.dart' as img;

// utils
import 'package:rando/services/firestore/firestore.dart';
import 'package:rando/services/storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rando/utils/global.dart';
import 'package:rando/utils/methods.dart';
import 'package:image_cropper/image_cropper.dart';

// ui
import 'package:rando/utils/theme/theme.dart';

class EditImage extends StatefulWidget {
  final String imgURL;
  final String docID;
  final String collection;
  final double height;
  final double width;
  final Function(Uint8List file) onFileChanged;
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
  StorageService storageService = StorageService();
  FirestoreService firestoreService = FirestoreService();
  Uint8List? pickedImage;
  bool isLoading = true;

  final ImagePicker picker = ImagePicker();
  String? imageURL;

  @override
  void initState() {
    super.initState();
    print(widget.imgURL);
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
        final imageBytes = await storageService.getFile(widget.imgURL);
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

  Future selectPhoto() async {
    await showBottomModal(
      context,
      <Widget>[
        Row(
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
            CustomIconButton(
              icon: Icons.photo_library_outlined,
              label: "Photo Library",
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

      // crop file
      var file = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      );
      if (file == null) return;

      // compress image
      // final compressedImage = await compressImage(file.path, 35);

      // convert image
      final imageBytes = await file.readAsBytes();

      // convert to jpg
      final jpgFile = await storageService.convertToJPG(imageBytes);

      // get path
      String path =
          '${widget.collection}/${widget.docID}/${jpgFile.uri.pathSegments.last}';

      // upload file and get photo URL
      await storageService.uploadFile(path, jpgFile);

      // set photo url to firestore document
      await firestoreService.setPhotoURL(
        widget.collection,
        widget.docID,
        path,
      );

      // set state
      setState(() {
        imageURL = path;
        pickedImage = imageBytes;
        isLoading = false;
      });

      // return new fileURL
      widget.onFileChanged(imageBytes);

      // await uploadFile(file.path);
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

  // Future<File> compressImage(String path, int quality) async {
  //   // create new path
  //   final newPath = p.join(
  //     (await getTemporaryDirectory()).path,
  //     '${DateTime.now()}.${p.extension(path)}',
  //   );

  //   // get result
  //   final result = await FlutterImageCompress.compressAndGetFile(
  //     path,
  //     newPath,
  //     quality: quality,
  //   );

  //   // return result
  //   return result;
  // }

  @override
  void dispose() {
    storageService.cancelOperation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: selectPhoto,
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
