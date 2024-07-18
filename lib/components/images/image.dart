import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:rando/services/storage.dart';
import 'package:rando/utils/theme/theme.dart';

class ImageWidget extends StatefulWidget {
  final String imgURL;
  final double height;
  final double width;
  final BorderRadius borderRadius;

  const ImageWidget({
    Key? key,
    required this.imgURL,
    required this.height,
    required this.width,
    required this.borderRadius,
  }) : super(key: key);

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  late Future<Uint8List?> _imageFuture;
  final StorageService _storage = StorageService();

  @override
  void initState() {
    super.initState();
    _imageFuture = _fetchImage();
  }

  Future<Uint8List?> _fetchImage() async {
    if (widget.imgURL.isEmpty) {
      return null;
    } else {
      try {
        return await _storage.getFile(widget.imgURL);
      } catch (e) {
        return null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _imageFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget(context);
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return errorWidget(context);
        }

        return imageWidget(snapshot.data!);
      },
    );
  }

  Widget loadingWidget(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius,
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

  Widget imageWidget(Uint8List image) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: widget.borderRadius,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: MemoryImage(image),
        ),
      ),
    );
  }
}
