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
                const TitleText(text: UnknownStrings.empty),
                SecondaryText(text: message),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
