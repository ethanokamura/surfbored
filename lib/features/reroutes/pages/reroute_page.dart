import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ReroutePage extends StatelessWidget {
  const ReroutePage({super.key});
  static Page<dynamic> page() => const MaterialPage<void>(child: ReroutePage());
  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      top: false,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppBarText(
              text: AppStrings.pageNotFound,
            ),
            const VerticalSpacer(),
            if (Navigator.canPop(context))
              ActionButton(
                text: AppStrings.returnHome,
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
