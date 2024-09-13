import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';

class SearchMetadata {
  const SearchMetadata(this.nbHits);

  factory SearchMetadata.fromResponse(SearchResponse response) =>
      SearchMetadata(response.nbHits);

  final int nbHits;
}
