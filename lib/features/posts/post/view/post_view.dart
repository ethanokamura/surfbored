import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:comment_repository/comment_repository.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/boards/boards.dart';
import 'package:surfbored/features/comments/comments.dart';
import 'package:surfbored/features/posts/cubit/post_cubit.dart';
import 'package:surfbored/features/posts/edit_post/edit_post.dart';
import 'package:surfbored/features/posts/likes/likes.dart';
import 'package:surfbored/features/profile/profile.dart';
import 'package:surfbored/features/tags/tags.dart';
import 'package:user_repository/user_repository.dart';

class PostView extends StatelessWidget {
  const PostView({
    required this.postCubit,
    required this.post,
    super.key,
  });
  final PostCubit postCubit;
  final Post post;
  @override
  Widget build(BuildContext context) {
    final userId = context.read<UserRepository>().user.uuid;
    return Flexible(
      child: CustomContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.photoUrl != null && post.photoUrl! != '')
              ImageHeader(post: post, userId: userId, postCubit: postCubit)
            else
              Header(post: post, userId: userId, postCubit: postCubit),
            if (post.photoUrl != null && post.photoUrl! != '')
              const VerticalSpacer(),
            TitleText(text: post.title),
            if (post.description.isNotEmpty)
              DescriptionText(text: post.description),
            if (post.description.isNotEmpty) const VerticalSpacer(),
            if (post.websiteUrl.isNotEmpty) WebLink(url: post.websiteUrl),
            if (post.websiteUrl.isNotEmpty) const VerticalSpacer(),
            if (post.tags.isNotEmpty) TagList(tags: post.tags.split(' ')),
            if (post.tags.isNotEmpty) const VerticalSpacer(),
            Footer(post: post, userId: userId),
          ],
        ),
      ),
    );
  }
}

class ImageHeader extends StatelessWidget {
  const ImageHeader({
    required this.post,
    required this.userId,
    required this.postCubit,
    super.key,
  });
  final Post post;
  final String userId;
  final PostCubit postCubit;
  @override
  Widget build(BuildContext context) {
    final isOwner = userId == post.creatorId;
    return Stack(
      children: [
        ImageWidget(
          borderRadius: defaultBorderRadius,
          photoUrl: post.photoUrl,
          // height: 256,
          width: double.infinity,
        ),
        Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MoreOptions(
                isOwner: isOwner,
                onManage: () => _manage(context, post.id!, userId),
                onEdit: () => _onEdit(context, post.id!, postCubit),
                onDelete: () => _onDelete(context, post, postCubit),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    required this.post,
    required this.userId,
    required this.postCubit,
    super.key,
  });
  final Post post;
  final String userId;
  final PostCubit postCubit;
  @override
  Widget build(BuildContext context) {
    final isOwner = userId == post.creatorId;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        MoreOptions(
          isOwner: isOwner,
          onManage: () => _manage(context, post.id!, userId),
          onEdit: () => _onEdit(context, post.id!, postCubit),
          onDelete: () => _onDelete(context, post, postCubit),
        ),
      ],
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
  const Footer({required this.post, required this.userId, super.key});
  final Post post;
  final String userId;

  @override
  Widget build(BuildContext context) {
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

void _manage(
  BuildContext context,
  int postId,
  String userId,
) =>
    Navigator.push(
      context,
      MaterialPageRoute<dynamic>(
        builder: (context) => SelectBoardPage(
          postId: postId,
          userId: userId,
        ),
      ),
    );

void _onEdit(
  BuildContext context,
  int postId,
  PostCubit postCubit,
) =>
    Navigator.push(
      context,
      MaterialPageRoute<dynamic>(
        builder: (context) {
          return BlocProvider.value(
            value: postCubit,
            child: EditPostPage(postId: postId),
          );
        },
      ),
    );

Future<void> _onDelete(
  BuildContext context,
  Post post,
  PostCubit postCubit,
) async {
  if (Navigator.canPop(context)) Navigator.pop(context);
  await postCubit.deletePost(
    post.creatorId,
    post.id!,
    post.photoUrl.toString(),
  );
  if (context.mounted && Navigator.canPop(context)) {
    Navigator.pop(context);
  }
}
