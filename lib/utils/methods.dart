import 'package:flutter/material.dart';
import 'package:rando/components/buttons/custom_button.dart';
import 'package:rando/utils/theme/theme.dart';

Future<void> editTextField(
  BuildContext context,
  String field,
  int maxLength,
  TextEditingController textController,
) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
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
              child: CustomButton(
                onTap: () => Navigator.pop(context),
                text: "Cancel",
              ),
            ),
            const SizedBox(width: 20),
            // save
            Expanded(
              child: CustomButton(
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
