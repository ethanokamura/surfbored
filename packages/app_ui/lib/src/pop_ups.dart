import 'package:app_ui/app_ui.dart';

// dynamic input length maximum
int maxInputLength(String field) {
  if (field == 'title') return 40;
  if (field == 'username') return 15;
  if (field == 'name') return 30;
  if (field == 'bio') return 150;
  if (field == 'link') return 150;
  if (field == 'description') return 150;
  return 50;
}

Future<String?> editTextField(
  BuildContext context,
  String field,
  TextEditingController textController,
) async {
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: context.theme.colorScheme.surface,
      title: TitleText(text: '${AppStrings.edit} $field:'),
      content: TextFormField(
        cursorColor: context.theme.subtextColor,
        controller: textController,
        autofocus: true,
        maxLength: maxInputLength(field),
        maxLines: null,
        decoration: InputDecoration(
          hintText: '${PromptStrings.enter} $field',
          hintStyle: TextStyle(
            fontSize: 18,
            color: context.theme.hintTextColor,
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            // Cancel
            Expanded(
              child: ActionButton(
                onTap: () => Navigator.pop(context),
                text: ButtonStrings.cancel,
              ),
            ),
            const HorizontalSpacer(),

            // Save
            Expanded(
              child: ActionButton(
                onTap: () => Navigator.of(context).pop(textController.text),
                text: ButtonStrings.save,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Future<dynamic> showBottomModal(
  BuildContext context,
  List<Widget> children,
) async {
  await context.showScrollControlledBottomSheet<void>(
    builder: (context) => Padding(
      padding: const EdgeInsets.only(
        top: 20,
        left: 30,
        right: 30,
        bottom: 60,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    ),
  );
}
