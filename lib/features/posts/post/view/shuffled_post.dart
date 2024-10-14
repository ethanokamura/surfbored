import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:comment_repository/comment_repository.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/comments/comments.dart';
import 'package:surfbored/features/images/images.dart';
import 'package:surfbored/features/posts/post/like_button/likes.dart';
import 'package:surfbored/features/profile/profile.dart';
import 'package:surfbored/features/tags/tags.dart';
import 'package:user_repository/user_repository.dart';

class ShuffledPost extends StatelessWidget {
  const ShuffledPost({
    required this.post,
    super.key,
  });
  final Post post;
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: CustomContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.photoUrl != null && post.photoUrl! != '')
              ImageWidget(
                key: ValueKey(post.photoUrl),
                borderRadius: defaultBorderRadius,
                photoUrl: post.photoUrl,
                // height: 256,
                width: double.infinity,
                aspectX: 4,
                aspectY: 3,
              ),
            if (post.photoUrl != null && post.photoUrl! != '')
              const VerticalSpacer(),
            TitleText(text: post.title),
            if (post.description.isNotEmpty)
              DescriptionText(text: post.description),
            if (post.description.isNotEmpty) const VerticalSpacer(),
            if (post.link.isNotEmpty) WebLink(url: post.link),
            if (post.link.isNotEmpty) const VerticalSpacer(),
            if (post.tags.isNotEmpty) TagList(tags: post.tags.split('+')),
            if (post.tags.isNotEmpty) const VerticalSpacer(),
            Footer(post: post),
          ],
        ),
      ),
    );
  }
}

class PostDetails extends StatelessWidget {
  const PostDetails({
    required this.title,
    required this.description,
    super.key,
  });
  final String title;
  final String description;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(text: title),
        DescriptionText(text: description),
      ],
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({required this.post, super.key});
  final Post post;

  @override
  Widget build(BuildContext context) {
    final userId = context.read<UserRepository>().user.uuid;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        UserDetails(id: post.creatorId),
        FutureBuilder(
          future: context
              .read<CommentRepository>()
              .fetchTotalComments(postId: post.id!),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Row(
                children: [
                  CommentButton(
                    postId: post.id!,
                    postCreatorId: post.creatorId,
                    comments: snapshot.data!,
                  ),
                  const HorizontalSpacer(),
                  LikeButton(post: post, userId: userId),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
