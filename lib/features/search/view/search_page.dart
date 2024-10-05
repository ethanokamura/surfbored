import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/posts/shared/post_list/view/post_list_view.dart';
import 'package:surfbored/features/search/cubit/search_cubit.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  static Page<dynamic> page() => const MaterialPage<void>(child: SearchPage());

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // search bar controller
  final _searchTextController = TextEditingController();
  Timer? _debounce;
  String _query = '';

  int currentPage = 0;
  final int pageSize = 10;
  bool hasMore = true;
  List<Post> _posts = [];

  @override
  void dispose() {
    _searchTextController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _searchForPosts(
    BuildContext context,
    String query, {
    bool refresh = false,
  }) async {
    if (refresh) {
      currentPage = 0;
      hasMore = true;
      setState(() => _posts = []);
    }
    if (!hasMore) return;
    try {
      final posts = await context.read<PostRepository>().searchPosts(
            query: query,
            offset: currentPage * pageSize,
            limit: pageSize,
          );
      if (posts.isEmpty) {
        hasMore = false; // No more posts to load
        setState(() => _posts = []);
      } else {
        currentPage++; // Increment the page number
        setState(() => _posts.addAll(posts));
      }
    } on PostFailure catch (failure) {
      throw Exception('query failure $failure');
    }
  }

  Future<void> _onSearchChanged(BuildContext context, String query) async {
    if (query.isEmpty) return;
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() {
        _query = query;
      });
      if (query.isNotEmpty) {
        await _searchForPosts(context, query, refresh: true);
      }
    });
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
                    onChanged: (value) async => _onSearchChanged(
                      context,
                      value.trim(),
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: defaultPadding,
                      ),
                      label: const PrimaryText(text: AppStrings.searchText),
                      prefixIcon: defaultIconStyle(context, AppIcons.search),
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
            if (_query.isNotEmpty)
              Expanded(
                child: PostListView(
                  posts: _posts,
                  onLoadMore: () async =>
                      context.read<SearchCubit>().searchForPosts(_query),
                  onRefresh: () async => context
                      .read<SearchCubit>()
                      .searchForPosts(_query, refresh: true),
                ),
              )
            else
              const PrimaryText(
                text: 'Enter a tag, title or description of something',
              ),
          ],
        ),
      ),
    );
  }
}
