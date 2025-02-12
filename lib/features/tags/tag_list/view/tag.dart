import 'package:app_ui/app_ui.dart';

class Tag extends StatelessWidget {
  const Tag({required this.tag, super.key});
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.theme.colorScheme.primary,
      shadowColor: context.theme.shadowColor,
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        child: CustomText(
          text: tag,
          fontSize: 14,
          style: primaryText,
        ),
      ),
    );
  }
}
