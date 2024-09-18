import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:app_core/app_core.dart';
import 'package:surfbored/features/search/view/post_results.dart';

part 'search_state.dart';

class PostSearchCubit extends Cubit<PostSearchState> {
  PostSearchCubit(this._postsSearcher) : super(PostSearchInitial());
  final HitsSearcher _postsSearcher;

  void initSearch() {
    // Start listening to search results
    _postsSearcher.responses.map(PostResults.fromResponse).listen((results) {
      emit(PostSearchSuccess(results));
    }).onError((dynamic error) {
      emit(PostSearchFailure(error.toString()));
    });
  }

  void search(String query, int pageKey) {
    // Apply state to the HitsSearcher
    _postsSearcher.applyState(
      (state) => state.copyWith(
        query: query,
        page: pageKey,
      ),
    );
  }

  @override
  Future<void> close() {
    _postsSearcher.dispose();
    return super.close();
  }
}
