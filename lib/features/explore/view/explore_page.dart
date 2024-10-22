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
        title: const AppBarText(text: PageStrings.explorePage, fontSize: 28),
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
            icon: appBarIconStyle(context, AppIcons.search, size: 24),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const TitleText(text: AppStrings.myFriends),
            const VerticalSpacer(),
            const PostFeed(),
          ],
        ),
      ),
    );
  }
}
