import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/search/cubit/search_cubit.dart';
import 'package:user_repository/user_repository.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchTextController = TextEditingController();

  // show search bar with search button
  // listen to text controller changes for realtime search?
  // look into fuzzy search with supabase!
  // show tab view for posts/users/boards
  // show list of results!

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchCubit(
        boardRepository: context.read<BoardRepository>(),
        userRepository: context.read<UserRepository>(),
        postRepository: context.read<PostRepository>(),
      ),
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          return CustomContainer(
            vertical: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                defaultIconStyle(context, AppIcons.search),
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
          );
        },
      ),
    );
  }
}
