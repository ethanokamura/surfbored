import 'package:app_ui/src/buttons.dart';
import 'package:app_ui/src/text.dart';
import 'package:app_ui/src/theme.dart';
import 'package:app_ui/src/widgets.dart';
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
      title: TitleText(text: 'Edit $field:'),
      content: TextFormField(
        cursorColor: Theme.of(context).subtextColor,
        controller: textController,
        autofocus: true,
        maxLength: maxInputLength(field),
        maxLines: null,
        decoration: InputDecoration(
          hintText: 'Enter new $field',
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
                text: 'Cancel',
              ),
            ),
            const HorizontalSpacer(),

            // Save
            Expanded(
              child: ActionButton(
                inverted: true,
                onTap: () => Navigator.of(context).pop(textController.text),
                text: 'Save',
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
