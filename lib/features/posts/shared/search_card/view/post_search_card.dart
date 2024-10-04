import 'package:app_ui/app_ui.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/posts/posts.dart';

class PostSearchCard extends StatelessWidget {
  const PostSearchCard({required this.post, super.key});
  final Post post;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => postSearchPopUp(context, post),
      child: CustomContainer(
        child: Row(
          children: [
            if (post.photoUrl != null && post.photoUrl! != '')
              SquareImage(
                borderRadius: defaultBorderRadius,
                photoUrl: post.photoUrl,
                height: 64,
                width: 64,
              ),
            if (post.photoUrl != null && post.photoUrl! != '')
              const HorizontalSpacer(),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TitleText(text: post.title),
                  SecondaryText(text: post.description, maxLines: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
