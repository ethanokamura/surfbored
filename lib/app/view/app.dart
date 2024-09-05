import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:rando/app/cubit/app_cubit.dart';
import 'package:rando/features/home/home.dart';
import 'package:rando/features/login/login.dart';
import 'package:rando/features/reroutes/reroutes.dart';
import 'package:rando/theme/theme_cubit.dart';
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
    required this.postRepository,
    required this.boardRepository,
    required this.userRepository,
    super.key,
  });

  final BoardRepository boardRepository;
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
