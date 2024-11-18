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
      top: false,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.transparent,
        title: AppBarText(text: context.l10n.explorePage),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<dynamic>(
                builder: (context) {
                  return const SearchPage();
                },
              ),
            ),
            icon: appBarIconStyle(context, AppIcons.search),
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[],
              ),
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.only(bottom: defaultPadding),
          child: Column(
            children: [
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
        ),
      ),
    );
  }
}
