import 'package:app_ui/app_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> showImagePicker({
  required BuildContext context,
  required Future<void> Function(ImageSource) onSelected,
}) async {
  await showBottomModal(
    context,
    <Widget>[
      TitleText(text: AppLocalizations.of(context)!.selectMedia, fontSize: 24),
      const VerticalSpacer(),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BottomModalButton(
            icon: AppIcons.camera,
            label: AppLocalizations.of(context)!.camera,
            onTap: () async {
              Navigator.pop(context);
              await onSelected(ImageSource.camera);
            },
          ),
          const SizedBox(width: 40),
          BottomModalButton(
            icon: AppIcons.posts,
            label: AppLocalizations.of(context)!.library,
            onTap: () async {
              Navigator.pop(context);
              await onSelected(ImageSource.gallery);
            },
          ),
        ],
      ),
    ],
  );
}
