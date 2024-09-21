import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

// dynamic input length maximum
int maxInputLength(String field) {
  if (field == 'title') return 40;
  if (field == 'username') return 15;
  if (field == 'name') return 30;
  if (field == 'bio') return 150;
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: TitleText(text: '${AppStrings.edit} $field:'),
      content: TextFormField(
        cursorColor: Theme.of(context).subtextColor,
        controller: textController,
        autofocus: true,
        maxLength: maxInputLength(field),
        maxLines: null,
        decoration: InputDecoration(
          hintText: '${AppStrings.enterField} $field',
          hintStyle: TextStyle(
            fontSize: 18,
            color: Theme.of(context).hintTextColor,
          ),
        ),
      ),
      actions: [
        Row(
          children: [
            // Cancel
            Expanded(
              child: ActionButton(
                inverted: true,
                onTap: () => Navigator.pop(context),
                text: AppStrings.cancel,
              ),
            ),
            const HorizontalSpacer(),

            // Save
            Expanded(
              child: ActionButton(
                inverted: true,
                onTap: () => Navigator.of(context).pop(textController.text),
                text: AppStrings.save,
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
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Theme.of(context).colorScheme.surface,
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
