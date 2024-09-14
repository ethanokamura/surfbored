import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:post_repository/post_repository.dart';
import 'package:rando/features/posts/posts.dart';
import 'package:rando/features/search/view/post_results.dart';
import 'package:rando/features/search/view/search_metadata.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  static Page<dynamic> page() => const MaterialPage<void>(child: SearchPage());

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // search bar controller
  final _searchTextController = TextEditingController();

  // pagination controller
  final PagingController<int, Post> _pagingController =
      PagingController(firstPageKey: 0);

  // get algolia index:
  final _postsSearcher = HitsSearcher(
    applicationID: dotenv.env['ALGOLIA_APP_ID']!,
    apiKey: dotenv.env['ALGOLIA_SEARCH_ID']!,
    indexName: 'Posts',
  );

  // stream hits:
  Stream<SearchMetadata> get _searchMetadata =>
      _postsSearcher.responses.map(SearchMetadata.fromResponse);

  // stream results:
  Stream<PostResults> get _searchPage =>
      _postsSearcher.responses.map(PostResults.fromResponse);

  @override
  void initState() {
    super.initState();
    _searchTextController.addListener(
      () => _postsSearcher.applyState(
        (state) => state.copyWith(
          query: _searchTextController.text,
          page: 0,
        ),
      ),
    );
    _searchPage.listen((page) {
      if (page.pageKey == 0) {
        _pagingController.refresh();
      }
      _pagingController.appendPage(page.items, page.nextPageKey);
    }).onError((dynamic error) => _pagingController.error = error);
    _pagingController.addPageRequestListener(
      (pageKey) => _postsSearcher.applyState(
        (state) => state.copyWith(
          page: pageKey,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    _postsSearcher.dispose();
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      top: false,
      body: Column(
        children: <Widget>[
          CustomContainer(
            inverted: false,
            horizontal: null,
            vertical: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search),
                const HorizontalSpacer(),
                Expanded(
                  child: TextField(
                    controller: _searchTextController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search for something new',
                    ),
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder<SearchMetadata>(
            stream: _searchMetadata,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Text('${snapshot.data!.nbHits} results'),
              );
            },
          ),
          Expanded(child: _results(context, _pagingController)),
        ],
      ),
    );
  }

  Widget _results(
    BuildContext context,
    PagingController<int, Post> pagingController,
  ) =>
      PagedListView<int, Post>.separated(
        padding: const EdgeInsets.only(bottom: defaultPadding),
        pagingController: pagingController,
        separatorBuilder: (context, index) => const VerticalSpacer(),
        builderDelegate: PagedChildBuilderDelegate<Post>(
          itemBuilder: (_, post, __) => PostSearchCard(post: post),
          firstPageErrorIndicatorBuilder: (context) => _errorIndicator(),
          newPageErrorIndicatorBuilder: (context) => _errorIndicator(),
          firstPageProgressIndicatorBuilder: (context) => _loadIndicator(),
          newPageProgressIndicatorBuilder: (context) => _loadIndicator(),
        ),
      );

  Widget _errorIndicator() => const Center(
        child: PrimaryText(text: 'error loading post'),
      );
  Widget _loadIndicator() => const Center(
        child: CircularProgressIndicator(),
      );
}
