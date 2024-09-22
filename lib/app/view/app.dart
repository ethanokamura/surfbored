import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:comment_repository/comment_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/app/cubit/app_cubit.dart';
import 'package:surfbored/features/home/home.dart';
import 'package:surfbored/features/login/login.dart';
import 'package:surfbored/features/reroutes/reroutes.dart';
import 'package:surfbored/theme/theme_cubit.dart';
import 'package:user_repository/user_repository.dart';

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
  if (status.isNewlyAuthenticatedWithoutUsername) {
    return [SignUpPage.page()];
  }
  return pages;
}

class App extends StatelessWidget {
  const App({
    required this.boardRepository,
    required this.commentRepository,
    required this.postRepository,
    required this.userRepository,
    super.key,
  });

  final BoardRepository boardRepository;
  final CommentRepository commentRepository;
  final PostRepository postRepository;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
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
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(
            create: (_) => ThemeCubit(),
          ),
          BlocProvider<AppCubit>(
            create: (_) => AppCubit(userRepository: userRepository),
          ),
        ],
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
            return MaterialPageRoute(builder: (_) => const ReroutePage());
          },
          debugShowCheckedModeBanner: false,
          home: BlocListener<AppCubit, AppState>(
            listenWhen: (_, current) => current.isFailure,
            listener: (context, state) {
              return switch (state.failure) {
                AuthUserChangesFailure() =>
                  context.showSnackBar(AppStrings.authFailure),
                SignOutFailure() =>
                  context.showSnackBar(AppStrings.authFailure),
                _ => context.showSnackBar(AppStrings.unknownFailure),
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
