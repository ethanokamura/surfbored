import 'package:flutter/material.dart';
import 'package:rando/components/buttons/defualt_button.dart';
import 'package:rando/utils/theme/theme.dart';

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
