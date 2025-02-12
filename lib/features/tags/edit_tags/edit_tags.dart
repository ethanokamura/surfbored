import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/tags/tags.dart';

class EditTagsPrompt extends StatelessWidget {
  const EditTagsPrompt({
    required this.tags,
    required this.updateTags,
    required this.label,
    super.key,
  });
  final List<String> tags;
  final String label;
  final void Function(List<String>) updateTags;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: label,
                fontSize: 22,
                style: primaryText,
              ),
              CustomButton(
                icon: AppIcons.edit,
                onTap: () => Navigator.push(
                  context,
                  bottomSlideTransition(
                    AddTagsPage(
                      tags: tags,
                      label: label,
                      returnTags: updateTags,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (tags.isNotEmpty) const VerticalSpacer(),
          TagList(tags: tags),
        ],
      ),
    );
  }
}
