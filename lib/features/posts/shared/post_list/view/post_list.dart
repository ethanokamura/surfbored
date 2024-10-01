import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/posts/posts.dart';
import 'package:surfbored/features/posts/shared/post_list/view/post_list_view.dart';
import 'package:tag_repository/tag_repository.dart';

class PostsList extends StatelessWidget {
  const PostsList({required this.type, required this.docID, super.key});
  final int docID;
  final String type;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostCubit(
        postRepository: context.read<PostRepository>(),
        tagRepository: context.read<TagRepository>(),
      )..fetchPosts(type: type, docId: docID, refresh: false),
      child: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isLoaded) {
            final posts = state.posts;
            return PostListView(
              posts: posts,
              onLoadMore: () async => context.read<PostCubit>().fetchPosts(
                    type: type,
                    docId: docID,
                    refresh: false,
                  ),
              onRefresh: () async => context.read<PostCubit>().fetchPosts(
                    type: type,
                    docId: docID,
                    refresh: true,
                  ),
            );
          } else if (state.isEmpty) {
            return const Center(
              child: PrimaryText(text: AppStrings.emptyPosts),
            );
          } else if (state.isDeleted || state.isUpdated) {
            context.read<PostCubit>().fetchPosts(
                  type: type,
                  docId: docID,
                  refresh: false,
                );
            return const Center(
              child: PrimaryText(text: AppStrings.changedPosts),
            );
          }
          return const Center(
            child: PrimaryText(text: AppStrings.fetchFailure),
          );
        },
      ),
    );
  }
}
