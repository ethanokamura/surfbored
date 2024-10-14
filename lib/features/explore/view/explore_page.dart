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
        backgroundColor: Colors.transparent,
        title: const AppBarText(text: '🌊 ${AppStrings.appTitle} 🌊'),
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
            icon: defaultIconStyle(context, AppIcons.search),
          ),
        ],
      ),
      body: const PostFeed(),
    );
  }
}
