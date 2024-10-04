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
        color: Theme.of(context).colorScheme.primary,
        shadowColor: Theme.of(context).shadowColor,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PrimaryText(text: tag, fontSize: 14),
              const SizedBox(width: 5),
              defaultIconStyle(context, AppIcons.cancel),
            ],
          ),
        ),
      ),
    );
  }
}
