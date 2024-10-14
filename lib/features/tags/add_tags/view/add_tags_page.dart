import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/tags/add_tags/view/edit_tag_list.dart';

class AddTagsPage extends StatefulWidget {
  const AddTagsPage({
    required this.returnTags,
    required this.tags,
    super.key,
  });

  final List<String> tags;
  final void Function(List<String> tags) returnTags;

  @override
  State<AddTagsPage> createState() => _AddTagsPageState();
}

class _AddTagsPageState extends State<AddTagsPage> {
  final TextEditingController _tagController = TextEditingController();
  late List<String> _tags;

  @override
  void initState() {
    _tags = widget.tags;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tagController.dispose();
  }

  void _deleteTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomPageView(
        top: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const AppBarText(text: TagStrings.create),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomContainer(
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: _tagController,
                        cursorColor: Theme.of(context).subtextColor,
                        decoration: const InputDecoration(
                          labelText: TagStrings.createSingle,
                        ),
                      ),
                    ),
                    ActionIconButton(
                      inverted: true,
                      icon: AppIcons.create,
                      onTap: () {
                        final tag = _tagController.text.trim();
                        if (tag.isNotEmpty) {
                          setState(() => _tags.add(tag));
                        }
                        _tagController.clear();
                      },
                    ),
                  ],
                ),
              ),
              const VerticalSpacer(),
              EditTagList(
                tags: _tags,
                onDelete: _deleteTag,
              ),
              const VerticalSpacer(),
              ActionAccentButton(
                text: ButtonStrings.confirm,
                onTap: () {
                  widget.returnTags(_tags);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
