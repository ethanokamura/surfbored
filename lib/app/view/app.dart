import 'package:app_ui/app_ui.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rando/app/cubit/app_cubit.dart';
import 'package:rando/app/generate_pages.dart';
import 'package:rando/theme/theme_cubit.dart';
import 'package:user_repository/user_repository.dart';

class App extends StatelessWidget {
  const App({required this.userRepository, super.key});

  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>.value(
          value: userRepository,
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
            child: FlowBuilder<AppState>(
              onGeneratePages: generateAppPages,
              state: context.select<AppCubit, AppState>(
                (cubit) => cubit.state,
              ),
            ),
          ),
        );
      },
    );
  }
}
