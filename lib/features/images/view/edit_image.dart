import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/images/cubit/image_cubit.dart';
import 'package:surfbored/features/images/images.dart';
import 'package:surfbored/features/images/view/helpers.dart';
import 'package:surfbored/features/images/view/image_modal.dart';

class EditImage extends StatelessWidget {
  const EditImage({
    required this.width,
    required this.docId,
    required this.userId,
    required this.collection,
    required this.photoUrl,
    required this.onFileChanged,
    required this.aspectX,
    required this.aspectY,
    super.key,
  });

  final String? photoUrl;
  final int docId;
  final String userId;
  final String collection;
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
                  context.read<ImageCubit>().pickAndUploadImage(
                        userId: userId,
                        docId: docId,
                        collection: collection,
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
