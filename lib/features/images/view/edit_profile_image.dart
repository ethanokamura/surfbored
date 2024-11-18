import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/images/cubit/image_cubit.dart';
import 'package:surfbored/features/images/images.dart';
import 'package:surfbored/features/images/view/helpers.dart';
import 'package:surfbored/features/images/view/image_modal.dart';

class EditProfileImage extends StatelessWidget {
  const EditProfileImage({
    required this.width,
    required this.userId,
    required this.photoUrl,
    required this.onFileChanged,
    required this.aspectX,
    required this.aspectY,
    super.key,
  });

  final String? photoUrl;
  final String userId;
  final double width;
  final double aspectX;
  final double aspectY;
  final void Function(String url) onFileChanged;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ImageCubit()..loadImage(photoUrl),
      child: BlocBuilder<ImageCubit, ImageState>(
        builder: (context, state) {
          if (state.isLoading) {
            return loadingWidget(
              context: context,
              aspectX: aspectX,
              aspectY: aspectY,
            );
          } else if (state.isLoaded) {
            onFileChanged(state.photoUrl!);
          }
          return GestureDetector(
            onTap: () async => showImagePicker(
              context: context,
              onSelected: (source) async =>
                  context.read<ImageCubit>().pickUserImage(
                        userId: userId,
                        source: source,
                        aspectX: aspectX,
                        aspectY: aspectY,
                      ),
            ),
            child: ImageWidget(
              width: width,
              photoUrl: photoUrl,
              borderRadius: defaultBorderRadius,
              aspectX: aspectX,
              aspectY: aspectY,
            ),
          );
        },
      ),
    );
  }
}
