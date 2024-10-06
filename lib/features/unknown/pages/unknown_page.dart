import 'package:app_ui/app_ui.dart';

class UnkownPage extends StatelessWidget {
  const UnkownPage({super.key});
  static Page<dynamic> page() => const MaterialPage<void>(child: UnkownPage());
  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const AppBarText(text: UnknownStrings.pageNotFoundTitle),
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
                  image: AssetImage(Theme.of(context).defaultImagePath),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const VerticalSpacer(),
            const VerticalSpacer(),
            const TitleText(text: UnknownStrings.pageNotFound),
          ],
        ),
      ),
    );
  }
}
