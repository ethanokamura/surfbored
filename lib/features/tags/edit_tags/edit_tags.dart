import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/tags/tag_list/view/view.dart';
import 'package:surfbored/features/tags/tags.dart';

class EditTagsBox extends StatelessWidget {
  const EditTagsBox({required this.tags, required this.updateTags, super.key});
  final List<String> tags;
  final void Function(List<String>) updateTags;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // section name
              const SecondaryText(text: AppStrings.editTags),
              ActionIconButton(
                background: false,
                inverted: true,
                icon: AppIcons.settings,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (context) => AddTagsPage(
                      tags: tags,
                      returnTags: updateTags,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // tags
          if (tags.isEmpty)
            const PrimaryText(text: AppStrings.emptyTags)
          else
            TagList(tags: tags),
        ],
      ),
    );
  }
}
