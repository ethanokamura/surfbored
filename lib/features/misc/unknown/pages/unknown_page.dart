import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';

class UnkownPage extends StatelessWidget {
  const UnkownPage({super.key});
  static MaterialPage<dynamic> page() =>
      const MaterialPage<void>(child: UnkownPage());
  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      title: context.l10n.pageNotFoundTitle,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                borderRadius: defaultBorderRadius,
                image: DecorationImage(
                  image: AssetImage(context.theme.defaultImagePath),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const VerticalSpacer(),
            const VerticalSpacer(),
            TitleText(text: context.l10n.pageNotFound),
          ],
        ),
      ),
    );
  }
}
