import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/pages/posts/posts.dart';
import 'package:rando/pages/profile/profile/cubit/user_cubit.dart';
import 'package:user_repository/user_repository.dart';

class PostList extends StatelessWidget {
  const PostList({required this.userID, super.key});
  final String userID;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit(
        userRepository: context.read<UserRepository>(),
      )..streamPosts(userID),
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isLoaded) {
            final posts = state.posts;
            return PostsGrid(
              posts: posts,
              onRefresh: () async {
                context
                    .read<UserCubit>()
                    .streamPosts(userID); // Refresh the posts
              },
            );
          } else if (state.isEmpty) {
            return const Center(child: Text('Item is empty.'));
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }
}
