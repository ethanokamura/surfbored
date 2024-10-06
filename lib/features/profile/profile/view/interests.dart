import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/tags/tags.dart';

class InterestsList extends StatelessWidget {
  const InterestsList({required this.interests, super.key});
  final List<String> interests;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SecondaryText(text: UserStrings.interests),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: TagList(tags: interests),
          ),
        ],
      ),
    );
  }
}
