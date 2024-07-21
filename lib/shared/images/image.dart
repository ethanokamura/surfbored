import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:rando/services/storage.dart';
import 'package:rando/config/theme.dart';

class ImageWidget extends StatefulWidget {
  final String? imgURL;
  final double height;
  final double width;
  final BorderRadius borderRadius;
  const ImageWidget({
    super.key,
    required this.imgURL,
    required this.height,
    required this.width,
    required this.borderRadius,
  });

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  String? imageURL;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getImageURL(widget.imgURL);
  }

  // invoked when the parent widget rebuilds
  // passes a new instance of the widget to the existing state object
  @override
  void didUpdateWidget(covariant ImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imgURL != widget.imgURL) {
      getImageURL(widget.imgURL);
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
