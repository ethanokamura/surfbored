import 'package:app_ui/app_ui.dart';

class EditTag extends StatelessWidget {
  const EditTag({required this.tag, required this.onDelete, super.key});
  final String tag;
  final void Function(String) onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onDelete(tag),
      child: Material(
        color: context.theme.colorScheme.primary,
        shadowColor: context.theme.shadowColor,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                text: tag,
                fontSize: 14,
                style: primaryText,
              ),
              const SizedBox(width: 5),
              defaultIconStyle(context, AppIcons.cancel, 0),
            ],
          ),
        ),
      ),
    );
  }
}
