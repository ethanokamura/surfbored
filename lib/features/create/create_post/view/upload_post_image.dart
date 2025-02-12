import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/create/cubit/create_cubit.dart';
import 'package:surfbored/features/images/images.dart';

class UploadPostImage extends StatelessWidget {
  const UploadPostImage({super.key});

  static MaterialPage<dynamic> page() =>
      const MaterialPage<void>(child: UploadPostImage());

  @override
  Widget build(BuildContext context) {
    return const UploadPostImageView();
  }
}

class UploadPostImageView extends StatefulWidget {
  const UploadPostImageView({super.key});
  @override
  State<UploadPostImageView> createState() => _UploadPostImageViewState();
}

class _UploadPostImageViewState extends State<UploadPostImageView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomText(text: context.l10n.uploadImage, style: titleText),
          const VerticalSpacer(),
          Center(
            child: UploadImage(
              width: 256,
              onFileChanged: (file) =>
                  context.read<CreateCubit>().uploadPostImage(file),
              aspectX: 4,
              aspectY: 3,
            ),
          ),
          const VerticalSpacer(),
          CustomText(text: context.l10n.skip, style: secondaryText),
        ],
      ),
    );
  }
}
