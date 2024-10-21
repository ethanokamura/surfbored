import 'package:app_ui/app_ui.dart';

Future<void> showImagePicker({
  required BuildContext context,
  required Future<void> Function(ImageSource) onSelected,
}) async {
  await showBottomModal(
    context,
    <Widget>[
      const TitleText(text: '${ImageStrings.selectMedia}:', fontSize: 24),
      const VerticalSpacer(),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BottomModalButton(
            icon: AppIcons.camera,
            label: ImageStrings.camera,
            onTap: () async {
              Navigator.pop(context);
              await onSelected(ImageSource.camera);
            },
          ),
          const SizedBox(width: 40),
          BottomModalButton(
            icon: AppIcons.posts,
            label: ImageStrings.photoLibrary,
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
