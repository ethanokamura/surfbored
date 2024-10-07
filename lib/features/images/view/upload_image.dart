import 'dart:io';

import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/images/cubit/image_cubit.dart';
import 'package:surfbored/features/images/images.dart';
import 'package:surfbored/features/images/view/helpers.dart';
import 'package:surfbored/features/images/view/image_modal.dart';

class UploadImage extends StatelessWidget {
  const UploadImage({
    required this.photoUrl,
    required this.width,
    required this.onFileChanged,
    required this.aspectX,
    required this.aspectY,
    super.key,
  });

  final ValueChanged<File> onFileChanged;
  final String? photoUrl;
  final double width;
  final double aspectX;
  final double aspectY;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ImageCubit(),
      child: BlocBuilder<ImageCubit, ImageState>(
        builder: (context, state) {
          if (state.isLoading) {
            return loadingWidget(
              context: context,
              aspectX: aspectX,
              aspectY: aspectY,
            );
          } else if (state.isLoaded) {
            onFileChanged(state.imageFile!);
            final pickedImage = state.imageFile!.readAsBytesSync();
            return picker(
              context,
              Image.memory(pickedImage),
            );
          }
          return picker(
            context,
            ImageWidget(
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

  Widget picker(BuildContext context, Widget child) {
    return GestureDetector(
      onTap: () async => showImagePicker(
        context: context,
        onSelected: (source) async => context.read<ImageCubit>().pickImage(
              source: source,
              aspectX: aspectX,
              aspectY: aspectY,
            ),
      ),
      child: child,
    );
  }
}
