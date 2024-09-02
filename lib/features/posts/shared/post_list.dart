import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:rando/features/posts/posts.dart';

class PostsList extends StatelessWidget {
  const PostsList({required this.type, required this.docID, super.key});
  final String docID;
  final String type;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostCubit(
        postRepository: context.read<PostRepository>(),
      )..streamPosts(type, docID),
      child: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isLoaded) {
            final posts = state.posts;
            return PostsGrid(
              posts: posts,
              hasMore: context.read<PostCubit>().hasMore(),
              onLoadMore: () async =>
                  context.read<PostCubit>().loadMorePosts(type, docID),
            );
          } else if (state.isEmpty) {
            return const Center(child: PrimaryText(text: 'No posts here!'));
          } else if (state.isDeleted || state.isUpdated) {
            context.read<PostCubit>().streamPosts(type, docID);
            return const Center(
              child: PrimaryText(text: 'Posts were changed. Reloading.'),
            );
          }
          return const Center(child: PrimaryText(text: 'Something went wrong'));
        },
      ),
      // ),
    );
  }
}
