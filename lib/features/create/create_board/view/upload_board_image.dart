import 'dart:io';

import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:surfbored/features/create/cubit/create_cubit.dart';
import 'package:surfbored/features/images/images.dart';

class UploadBoardImage extends StatelessWidget {
  const UploadBoardImage._();

  static MaterialPage<dynamic> page() => const MaterialPage<void>(
        key: ValueKey('upload_board_image'),
        child: UploadBoardImage._(),
      );

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
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: UploadImage(
              width: 256,
              onFileChanged: (file) => setState(() => imageFile = file),
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
                context.read<CreateCubit>().uploadBoardImage(imageFile),
          ),
        ],
      ),
    );
  }
}
