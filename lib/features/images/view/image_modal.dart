import 'package:app_ui/app_ui.dart';

Future<void> showImagePicker({
  required BuildContext context,
  required Future<void> Function(ImageSource) onSelected,
}) async {
  await showBottomModal(
    context,
    <Widget>[
      const TitleText(text: '${AppStrings.selectMedia}:', fontSize: 24),
      const VerticalSpacer(),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BottomModalButton(
            icon: AppIcons.camera,
            label: AppStrings.camera,
            onTap: () async {
              Navigator.pop(context);
              await onSelected(ImageSource.camera);
            },
          ),
          const SizedBox(width: 40),
          BottomModalButton(
            icon: AppIcons.posts,
            label: AppStrings.library,
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
