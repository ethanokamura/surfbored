import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/posts/posts.dart';
import 'package:surfbored/features/search/search.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});
  static MaterialPage<dynamic> page() =>
      const MaterialPage<void>(child: ExplorePage());

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      centerTitle: false,
      title: context.l10n.explorePage,
      actions: [
        AppBarButton(
          onTap: () => Navigator.push(
            context,
            bottomSlideTransition(const SearchPage()),
          ),
          icon: AppIcons.search,
        ),
      ],
      body: NestedWrapper(
        header: const [],
        body: [
          Row(
            children: [
              Expanded(
                child: ActionButton(
                  onTap: () {},
                  text: 'top rated',
                ),
              ),
              const HorizontalSpacer(),
              Expanded(
                child: ActionButton(
                  onTap: () {},
                  text: 'near me',
                ),
              ),
            ],
          ),
          const VerticalSpacer(),
          const Flexible(
            child: PostFeed(),
          ),
        ],
      ),
    );
  }
}
