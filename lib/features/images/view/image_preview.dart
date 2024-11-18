import 'dart:typed_data';
import 'package:app_ui/app_ui.dart';

class ImagePreview extends StatelessWidget {
  const ImagePreview({
    required this.image,
    required this.width,
    required this.borderRadius,
    required this.aspectX,
    required this.aspectY,
    super.key,
  });

  final Uint8List image;
  final double width;
  final double aspectX;
  final double aspectY;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: imagePreview(
        image: image,
        width: width,
        context: context,
        aspectX: aspectX,
        aspectY: aspectY,
        borderRadius: borderRadius,
      ),
    );
  }
}

Widget imagePreview({
  required BuildContext context,
  required double aspectX,
  required double aspectY,
  required double width,
  required Uint8List image,
  required BorderRadius borderRadius,
}) {
  return AspectRatio(
    aspectRatio: aspectX / aspectY,
    child: Container(
      decoration: BoxDecoration(
        color: context.theme.colorScheme.primary,
        borderRadius: borderRadius,
      ),
      child: Image.memory(image, fit: BoxFit.cover),
    ),
  );
}
