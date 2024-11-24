import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:comment_repository/comment_repository.dart';
import 'package:friend_repository/friend_repository.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/app/cubit/app_cubit.dart';
import 'package:surfbored/features/authentication/create_user/create_user.dart';
import 'package:surfbored/features/authentication/login/login.dart';
import 'package:surfbored/features/home/home.dart';
import 'package:surfbored/features/unknown/unknown.dart';
import 'package:surfbored/theme/theme_cubit.dart';
import 'package:tag_repository/tag_repository.dart';
import 'package:user_repository/user_repository.dart';

/// Generate pages based on AppStatus
List<Page<dynamic>> onGenerateAppPages(
  AppStatus status,
  List<Page<dynamic>> pages,
) {
  if (status.isUnauthenticated) {
    return [LoginPage.page()];
  }
  if (status.isNewlyAuthenticated) {
    return [HomePage.page()];
  }
  if (status.needsUsername) {
    return [CreateUserPage.page()];
  }
  return pages;
}

/// Construct the app
class App extends StatelessWidget {
  const App({
    required this.boardRepository,
    required this.commentRepository,
    required this.postRepository,
    required this.tagRepository,
    required this.friendRepository,
    required this.userRepository,
    super.key,
  });

  final BoardRepository boardRepository;
  final CommentRepository commentRepository;
  final PostRepository postRepository;
  final TagRepository tagRepository;
  final FriendRepository friendRepository;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    /// Define create instances
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>.value(
          value: userRepository,
        ),
        RepositoryProvider<PostRepository>.value(
          value: postRepository,
        ),
        RepositoryProvider<BoardRepository>.value(
          value: boardRepository,
        ),
        RepositoryProvider<CommentRepository>.value(
          value: commentRepository,
        ),
        RepositoryProvider<TagRepository>.value(
          value: tagRepository,
        ),
        RepositoryProvider<FriendRepository>.value(
          value: friendRepository,
        ),
      ],

      /// Initialize top level providers
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(
            create: (_) => ThemeCubit(),
          ),
          BlocProvider<AppCubit>(
            create: (_) => AppCubit(userRepository: userRepository),
          ),
        ],

        /// Return AppView
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return MaterialApp(
          onGenerateTitle: (context) => AppStrings.appTitle,
          theme: context.read<ThemeCubit>().themeData,
          onUnknownRoute: (settings) {
            return MaterialPageRoute(builder: (_) => const UnkownPage());
          },
          debugShowCheckedModeBanner: false,
          home: BlocListener<AppCubit, AppState>(
            listenWhen: (_, current) => current.isFailure,
            listener: (context, state) {
              return switch (state.failure) {
                AuthChangesFailure() =>
                  context.showSnackBar(AuthStrings.authFailure),
                SignOutFailure() =>
                  context.showSnackBar(AuthStrings.authFailure),
                _ => context.showSnackBar(AuthStrings.unknownFailure),
              };
            },
            child: FlowBuilder(
              onGeneratePages: onGenerateAppPages,
              state: context.select<AppCubit, AppStatus>(
                (cubit) => cubit.state.status,
              ),
            ),
          ),
        );
      },
    );
  }
}
