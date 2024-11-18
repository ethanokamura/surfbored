import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/images/view/image.dart';

class UnknownCard extends StatelessWidget {
  const UnknownCard({required this.message, super.key});
  final String message;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Row(
        children: [
          const ImageWidget(
            borderRadius: defaultBorderRadius,
            photoUrl: null,
            aspectX: 1,
            aspectY: 1,
            width: 64,
          ),
          const HorizontalSpacer(),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                TitleText(text: context.l10n.empty),
                SecondaryText(text: message),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
