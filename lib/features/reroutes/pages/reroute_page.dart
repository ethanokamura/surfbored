import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rando/features/reroutes/pop_ups/unknown_page.dart';

class ReroutePage extends StatelessWidget {
  const ReroutePage({super.key});
  static Page<dynamic> page() => const MaterialPage<void>(child: ReroutePage());
  @override
  Widget build(BuildContext context) {
    unknownPagePopup(context);
    return CustomPageView(
      top: false,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppBarText(
              text: 'Uh oh! Page not found.',
            ),
            const VerticalSpacer(),
            if (Navigator.canPop(context))
              ActionButton(
                text: 'Return Home',
                inverted: false,
                onTap: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
              ),
          ],
        ),
      ),
    );
  }
}
