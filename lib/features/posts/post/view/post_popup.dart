import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:comment_repository/comment_repository.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/boards/boards.dart';
import 'package:surfbored/features/comments/comments.dart';
import 'package:surfbored/features/images/images.dart';
import 'package:surfbored/features/posts/cubit/post_cubit.dart';
import 'package:surfbored/features/posts/edit_post/edit_post.dart';
import 'package:surfbored/features/posts/post/like_button/likes.dart';
import 'package:surfbored/features/profile/profile.dart';
import 'package:surfbored/features/tags/tags.dart';
import 'package:user_repository/user_repository.dart';

Future<dynamic> postPopUp(
  BuildContext context,
  Post post,
) async {
  final postCubit = context.read<PostCubit>();
  final userId = context.read<UserRepository>().user.uuid;
  final isOwner = userId == post.creatorId;

  await context.showScrollControlledBottomSheet<void>(
    builder: (context) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            if (post.photoUrl != null && post.photoUrl! != '')
              ImageWidget(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(defaultRadius),
                  topRight: Radius.circular(defaultRadius),
                ),
                photoUrl: post.photoUrl,
                aspectX: 4,
                aspectY: 3,
                width: double.infinity,
              ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton(
                    color: !(post.photoUrl != null && post.photoUrl! != '')
                        ? 1
                        : 0,
                    icon: AppIcons.cancel,
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(
            left: defaultPadding,
            right: defaultPadding,
            top: post.photoUrl != null && post.photoUrl! != ''
                ? defaultPadding
                : 0,
            bottom: 60,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomText(
                      text: post.title,
                      style: titleText,
                    ),
                  ),
                  MorePostOptions(
                    onSurface: false,
                    isOwner: isOwner,
                    onManage: () => Navigator.push(
                      context,
                      bottomSlideTransition(
                        SelectBoardPage(
                          postId: post.id!,
                          userId: userId,
                        ),
                      ),
                    ),
                    onEdit: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        bottomSlideTransition(
                          BlocProvider.value(
                            value: postCubit,
                            child: EditPostPage(post: post),
                          ),
                        ),
                      );
                    },
                    onDelete: () async {
                      Navigator.pop(context);
                      await postCubit.deletePost(
                        // post.creatorId,
                        post.id!,
                        // post.photoUrl.toString(),
                      );
                      if (context.mounted) Navigator.pop(context);
                    },
                  ),
                ],
              ),
              if (post.description.isNotEmpty)
                CustomText(text: post.description, style: secondaryText),
              if (post.description.isNotEmpty) const VerticalSpacer(),
              if (post.link.isNotEmpty) WebLink(url: post.link),
              if (post.link.isNotEmpty) const VerticalSpacer(),
              if (post.tags.isNotEmpty) TagList(tags: post.tags.split('+')),
              if (post.tags.isNotEmpty) const VerticalSpacer(),
              Row(
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
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
