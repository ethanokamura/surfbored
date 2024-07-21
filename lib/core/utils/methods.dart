import 'package:flutter/material.dart';
import 'package:rando/shared/widgets/buttons/defualt_button.dart';
import 'package:rando/config/theme.dart';

// global method to edit a text field
Future<void> editTextField(
  BuildContext context,
  String field,
  int maxLength,
  TextEditingController textController,
) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: Text(
        "Edit $field:",
        style: TextStyle(
          color: Theme.of(context).accentColor,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              controller: textController,
              autofocus: true,
              maxLength: maxLength,
              maxLines: null,
              decoration: InputDecoration(
                hintText: "Enter new $field",
                hintStyle: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).hintTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Row(
          children: [
            //cancel
            Expanded(
              child: DefualtButton(
                inverted: true,
                onTap: () => Navigator.pop(context),
                text: "Cancel",
              ),
            ),
            const SizedBox(width: 20),
            // save
            Expanded(
              child: DefualtButton(
                inverted: true,
                onTap: () => Navigator.of(context).pop(textController.text),
                text: "Save",
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Future<void> showBottomModal(
  BuildContext context,
  List<Widget> children,
) async {
  await showModalBottomSheet(
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    ),
  );
}
