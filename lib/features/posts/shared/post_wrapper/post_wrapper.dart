import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:rando/features/posts/posts.dart';

class PostWrapper extends StatelessWidget {
  const PostWrapper({required this.postID, super.key});
  final String postID;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostCubit(
        postRepository: context.read<PostRepository>(),
      )..streamPost(postID),
      child: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isLoaded) {
            return PostView(
              post: state.post,
              postCubit: context.read<PostCubit>(),
            );
          } else if (state.isEmpty) {
            return const Center(child: Text('This board is empty.'));
          } else {
            return const Center(child: Text('Something went wrong'));
          }
        },
      ),
    );
  }
}
