import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/images/cubit/image_cubit.dart';
import 'package:surfbored/features/images/view/helpers.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    required this.photoUrl,
    required this.width,
    required this.borderRadius,
    required this.aspectX,
    required this.aspectY,
    super.key,
  });

  final String? photoUrl;
  final double width;
  final double aspectX;
  final double aspectY;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ImageCubit()..loadImage(photoUrl),
      child: BlocBuilder<ImageCubit, ImageState>(
        builder: (context, state) {
          if (state.isLoading) {
            return SizedBox(
              width: width,
              child: loadingWidget(
                context: context,
                aspectX: aspectX,
                aspectY: aspectY,
              ),
            );
          } else if (state.isFailure) {
            return DefaultImage(
              width: width,
              aspectX: aspectX,
              aspectY: aspectY,
              borderRadius: borderRadius,
            );
          } else if (state.isLoaded) {
            return state.photoUrl == null || state.photoUrl!.isEmpty
                ? DefaultImage(
                    width: width,
                    aspectX: aspectX,
                    aspectY: aspectY,
                    borderRadius: borderRadius,
                  )
                : SizedBox(
                    width: width,
                    child: imageWidget(
                      width: width,
                      context: context,
                      data: state.photoUrl!,
                      aspectX: aspectX,
                      aspectY: aspectY,
                      borderRadius: borderRadius,
                    ),
                  );
          }
          return DefaultImage(
            width: width,
            aspectX: aspectX,
            aspectY: aspectY,
            borderRadius: borderRadius,
          );
        },
      ),
    );
  }
}
