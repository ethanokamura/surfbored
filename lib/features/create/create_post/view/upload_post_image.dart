import 'dart:io';

import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:surfbored/features/create/cubit/create_cubit.dart';
import 'package:surfbored/features/images/images.dart';

class UploadPostImage extends StatelessWidget {
  const UploadPostImage._();

  static MaterialPage<dynamic> page() => const MaterialPage<void>(
        key: ValueKey('upload_post_image'),
        child: UploadPostImage._(),
      );

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
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: AppBarText(text: AppLocalizations.of(context)!.uploadImage),
      ),
      top: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: UploadImage(
                width: 256,
                onFileChanged: (file) => imageFile = file,
                aspectX: 4,
                aspectY: 3,
              ),
            ),
            const VerticalSpacer(),
            SecondaryText(text: AppLocalizations.of(context)!.skip),
            const VerticalSpacer(),
            ActionButton(
              text: AppLocalizations.of(context)!.next,
              onTap: () =>
                  context.read<CreateCubit>().uploadPostImage(imageFile),
            )
          ],
        ),
      ),
    );
  }
}
