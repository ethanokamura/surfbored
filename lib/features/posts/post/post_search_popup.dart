import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/posts/likes/likes.dart';
import 'package:surfbored/features/posts/shared/more_search_options.dart';
import 'package:surfbored/features/profile/profile.dart';
import 'package:surfbored/features/tags/tags.dart';
import 'package:user_repository/user_repository.dart';

Future<dynamic> postSearchPopUp(
  BuildContext context,
  Post post,
) async {
  final userID = context.read<UserRepository>().user.uid;
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Theme.of(context).colorScheme.surface,
    isScrollControlled: true,
    builder: (context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              ImageWidget(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(defaultRadius),
                  topRight: Radius.circular(defaultRadius),
                ),
                photoURL: post.photoURL,
                width: double.infinity,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MoreSearchOptions(
                      postID: post.id,
                      userID: userID,
                    ),
                    LabeledIconButton(
                      icon: FontAwesomeIcons.xmark,
                      size: 20,
                      inverted: false,
                      onTap: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: defaultPadding,
              right: defaultPadding,
              top: defaultPadding,
              bottom: 60,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleText(text: post.title),
                DescriptionText(text: post.description),
                const VerticalSpacer(),
                TagList(tags: post.tags),
                const VerticalSpacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    UserDetails(uid: post.uid),
                    LikeButton(post: post, userID: userID),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}
