import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/posts/posts.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});
  static MaterialPage<dynamic> page() =>
      const MaterialPage<void>(child: FeedPage());

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      top: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const AppBarText(text: '🌊 ${AppStrings.appTitle} 🌊'),
      ),
      body: const PostFeed(),
    );
  }
}
