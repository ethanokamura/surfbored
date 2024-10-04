import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/posts/shared/post_list/view/post_list_view.dart';
import 'package:surfbored/features/search/cubit/search_cubit.dart';
import 'package:user_repository/user_repository.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  static Page<dynamic> page() => const MaterialPage<void>(child: SearchPage());

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // search bar controller
  final _searchTextController = TextEditingController();

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _searchTextController.addListener(
      () => context.read<SearchCubit>().setQuery(_searchTextController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomPageView(
        body: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _searchTextController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding,
                      ),
                      label: const PrimaryText(
                        text: AppStrings.searchText,
                      ),
                      prefixIcon: defaultIconStyle(
                        context,
                        AppIcons.search,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                const HorizontalSpacer(),
                ActionIconButton(
                  icon: AppIcons.cancel,
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
            const VerticalSpacer(),
            BlocProvider(
              create: (_) => SearchCubit(
                boardRepository: context.read<BoardRepository>(),
                userRepository: context.read<UserRepository>(),
                postRepository: context.read<PostRepository>(),
              ),
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.isLoaded) {
                    final posts = state.posts;
                    return Expanded(
                      child: PostListView(
                        posts: posts,
                        onLoadMore: () async =>
                            context.read<SearchCubit>().searchForPosts(),
                        onRefresh: () async => context
                            .read<SearchCubit>()
                            .searchForPosts(refresh: true),
                      ),
                    );
                  } else if (state.isEmpty) {
                    return const Center(
                      child: PrimaryText(text: AppStrings.emptyPosts),
                    );
                  } else if (state.isQueried) {
                    context.read<SearchCubit>().searchForPosts();
                    return const Center(
                      child: PrimaryText(text: AppStrings.changedPosts),
                    );
                  }
                  return const Center(
                    child: PrimaryText(text: AppStrings.fetchFailure),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultsList extends StatelessWidget {
  const ResultsList({super.key});

  @override
  Widget build(BuildContext context) {
    return const PrimaryText(
      text: 'results',
    );
  }
}
