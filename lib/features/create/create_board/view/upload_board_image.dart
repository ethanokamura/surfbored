import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/create/cubit/create_cubit.dart';
import 'package:surfbored/features/images/images.dart';

class UploadBoardImage extends StatelessWidget {
  const UploadBoardImage({super.key});

  static MaterialPage<dynamic> page() =>
      const MaterialPage<void>(child: UploadBoardImage());

  @override
  Widget build(BuildContext context) {
    return const UploadBoardImageView();
  }
}

class UploadBoardImageView extends StatefulWidget {
  const UploadBoardImageView({super.key});
  @override
  State<UploadBoardImageView> createState() => _UploadBoardImageViewState();
}

class _UploadBoardImageViewState extends State<UploadBoardImageView> {
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
