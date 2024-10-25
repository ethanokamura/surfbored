import 'package:app_ui/src/extensions.dart';
import 'package:flutter/material.dart';

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
