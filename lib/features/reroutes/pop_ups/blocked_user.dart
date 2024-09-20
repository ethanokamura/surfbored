import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

Future<void> blockedUserPopup(
  BuildContext context,
) async {
  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: const TitleText(text: AppStrings.blockedUser),
      actions: [
        // go back
        Expanded(
          child: ActionButton(
            inverted: true,
            onTap: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            text: AppStrings.goBack,
          ),
        ),
      ],
    ),
  );
}
