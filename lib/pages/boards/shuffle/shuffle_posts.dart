import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/pages/boards/shuffle/cubit/shuffle_posts_cubit.dart';
import 'package:rando/pages/posts/shared/post_wrapper/post_wrapper.dart';

class ShufflePostsPage extends StatelessWidget {
  const ShufflePostsPage({required this.boardID, super.key});
  final String boardID;
  static MaterialPage<void> page({required String boardID}) {
    return MaterialPage<void>(
      child: ShufflePostsPage(boardID: boardID),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShufflePostsCubit(
        boardRepository: context.read<BoardRepository>(),
      )..shufflePostList(boardID),
      child: CustomPageView(
        top: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Shuffle Posts'),
        ),
        body: BlocBuilder<ShufflePostsCubit, ShufflePostsState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.isLoaded) {
              return state.canIncrement || state.canDecrement
                  ? ShowPosts(state: state)
                  : const ShowEndOfList();
            } else if (state.isFailure) {
              return const Center(child: Text('Failure Loading Board'));
            } else {
              return const Center(child: Text('Unknown state'));
            }
          },
        ),
      ),
    );
  }
}

class ShowPosts extends StatelessWidget {
  const ShowPosts({required this.state, super.key});
  final ShufflePostsState state;
  @override
  Widget build(BuildContext context) {
    final posts = state.posts;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // show activity
          PostWrapper(postID: posts[state.index]),
          const VerticalSpacer(),
          Row(
            children: [
              Expanded(
                child: ActionButton(
                  inverted: false,
                  text: 'Last',
                  onTap: () {
                    if (state.canDecrement) {
                      context.read<ShufflePostsCubit>().decrementIndex();
                    }
                  },
                ),
              ),
              const HorizontalSpacer(),
              Expanded(
                child: ActionButton(
                  inverted: true,
                  text: 'Next',
                  onTap: () {
                    if (state.canIncrement) {
                      context.read<ShufflePostsCubit>().incrementIndex();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ShowEndOfList extends StatelessWidget {
  const ShowEndOfList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No more posts!'),
            const VerticalSpacer(),
            ActionButton(
              text: 'Return',
              inverted: true,
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
