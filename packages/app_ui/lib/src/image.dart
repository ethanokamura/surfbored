import 'package:app_ui/src/extensions.dart';
import 'package:app_ui/src/theme.dart';
import 'package:flutter/material.dart';

class DefaultImage extends StatelessWidget {
  const DefaultImage({
    required this.aspectX,
    required this.aspectY,
    required this.width,
    required this.borderRadius,
    super.key,
  });
  final double aspectX;
  final double aspectY;
  final double width;
  final BorderRadius borderRadius;
  @override
  Widget build(BuildContext context) {
    final x = width == double.infinity ? 64 : width / 4;
    return SizedBox(
      width: width,
      child: AspectRatio(
        aspectRatio: aspectX / aspectY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: context.theme.colorScheme.primary,
          ),
          child: Center(
            child: Container(
              width: x as double,
              height: x,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                image: DecorationImage(
                  image: AssetImage(context.theme.defaultImagePath),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
