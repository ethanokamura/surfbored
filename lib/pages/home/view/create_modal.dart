// dart packages
import 'package:flutter/material.dart';

// utils
import 'package:rando/core/utils/methods.dart';
import 'package:rando/config/theme.dart';

// components
import 'package:rando/shared/widgets/buttons/icon_button.dart';

// pages
import 'package:rando/pages/create/create.dart';

// ui libraries
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Future<void> showCreateMenu(BuildContext context) async {
  await showBottomModal(context, <Widget>[
    Text(
      "Create Something:",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Theme.of(context).textColor,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
    const SizedBox(height: 20),
    Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        CustomIconButton(
          icon: FontAwesomeIcons.mountain,
          label: "Activity",
          inverted: true,
          size: 40,
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateScreen(type: 'items'),
              ),
            );
          },
        ),
        const SizedBox(width: 40),
        CustomIconButton(
          icon: FontAwesomeIcons.list,
          label: "Board",
          inverted: true,
          size: 40,
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateScreen(type: 'boards'),
              ),
            );
          },
        ),
      ],
    ),
  ]);
}
