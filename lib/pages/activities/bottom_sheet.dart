import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:rando/pages/activities/cubit/activity_cubit.dart';
import 'package:rando/pages/activities/edit_activity/edit_activity.dart';
import 'package:rando/pages/activities/shared/activity/cubit/like_cubit.dart';
import 'package:rando/pages/activities/shared/activity/view/more_options.dart';
import 'package:rando/pages/profile/profile/profile.dart';
import 'package:user_repository/user_repository.dart';

Future<dynamic> showActivityModal(
  BuildContext context,
  Item item,
  ItemCubit itemCubit,
  void Function() onRefresh,
) async {
  final user = itemCubit.getUser();
  final isOwner = itemCubit.isOwner(
    item.uid,
    user.uid,
  );
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: Theme.of(context).colorScheme.surface,
    isScrollControlled: true,
    builder: (context) => Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            ImageWidget(
              borderRadius: defaultBorderRadius,
              photoURL: item.photoURL,
              height: 256,
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MoreOptions(
                    itemID: item.id,
                    userID: item.uid,
                    isOwner: isOwner,
                    imgURL: item.photoURL.toString(),
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (context) =>
                              EditActivityPage(itemID: item.id),
                        ),
                      );
                    },
                    onDelete: () async {
                      await itemCubit.deleteItem(
                        item.uid,
                        item.id,
                        item.photoURL.toString(),
                      );
                      if (context.mounted) Navigator.pop(context);
                      await Future<dynamic>.delayed(
                        const Duration(milliseconds: 300),
                      );
                      onRefresh();
                    },
                  ),
                  ActionIconButton(
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
              Text(
                item.title,
                style: TextStyle(
                  color: Theme.of(context).textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              Text(
                item.description,
                style: TextStyle(
                  color: Theme.of(context).subtextColor,
                  fontSize: 18,
                ),
              ),
              const VerticalSpacer(),
              TagList(tags: item.tags),
              const VerticalSpacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  LinkWidget(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (context) => ProfilePage(userID: item.uid),
                      ),
                    ),
                    text: '@${user.username}',
                  ),
                  BlocProvider(
                    create: (context) =>
                        LikeCubit(context.read<ItemsRepository>()),
                    child: BlocBuilder<LikeCubit, LikeState>(
                      builder: (context, state) {
                        var isCurrentlyLiked =
                            user.hasLikedItem(itemID: item.id);
                        var likes = item.likes;
                        if (state is LikeLoading) {
                          // Show a loading indicator in the button if needed
                        } else if (state is LikeSuccess) {
                          isCurrentlyLiked = state.isLiked;
                          likes = state.likes;
                        }
                        return LikeButton(
                          onTap: () => context.read<LikeCubit>().toggleLike(
                                user.uid,
                                item.id,
                                liked: isCurrentlyLiked,
                              ),
                          isLiked: isCurrentlyLiked,
                          likes: likes,
                        );
                      },
                    ),
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
