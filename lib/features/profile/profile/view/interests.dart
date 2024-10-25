import 'package:app_ui/app_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
          SecondaryText(text: AppLocalizations.of(context)!.interests),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: TagList(tags: interests),
          ),
        ],
      ),
    );
  }
}
