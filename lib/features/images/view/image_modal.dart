import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';

Future<void> showImagePicker({
  required BuildContext context,
  required Future<void> Function(ImageSource) onSelected,
}) async {
  await showBottomModal(
    context,
    <Widget>[
      TitleText(text: context.l10n.selectMedia, fontSize: 24),
      const VerticalSpacer(),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BottomModalButton(
            icon: AppIcons.camera,
            label: context.l10n.camera,
            onTap: () async {
              Navigator.pop(context);
              await onSelected(ImageSource.camera);
            },
          ),
          const SizedBox(width: 40),
          BottomModalButton(
            icon: AppIcons.posts,
            label: context.l10n.library,
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
