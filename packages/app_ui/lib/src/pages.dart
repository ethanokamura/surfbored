import 'package:app_core/app_core.dart';
import 'package:app_ui/src/constants.dart';
import 'package:app_ui/src/image.dart';
import 'package:app_ui/src/text.dart';
import 'package:app_ui/src/widgets.dart';
import 'package:flutter/material.dart';

class UnknownPage extends StatelessWidget {
  const UnknownPage({super.key});
  static MaterialPage<dynamic> page() =>
      const MaterialPage<void>(child: UnknownPage());
  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      title: context.l10n.pageNotFoundTitle,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DefaultImage(
              width: 64,
              aspectX: 1,
              aspectY: 1,
              borderRadius: defaultBorderRadius,
            ),
            const VerticalSpacer(),
            const VerticalSpacer(),
            CustomText(text: context.l10n.pageNotFound, style: titleText),
          ],
        ),
      ),
    );
  }
}
