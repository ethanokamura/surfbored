import 'package:app_ui/app_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UnkownPage extends StatelessWidget {
  const UnkownPage({super.key});
  static MaterialPage<dynamic> page() =>
      const MaterialPage<void>(child: UnkownPage());
  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title:
            AppBarText(text: AppLocalizations.of(context)!.pageNotFoundTitle),
      ),
      top: true,
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
            TitleText(text: AppLocalizations.of(context)!.pageNotFound),
          ],
        ),
      ),
    );
  }
}
