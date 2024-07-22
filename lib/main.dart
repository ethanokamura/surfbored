// dart packages
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// firebase packages
import 'package:firebase_core/firebase_core.dart';
import 'package:rando/config/global.dart';
import 'package:rando/core/services/auth_service.dart';
import 'package:rando/core/services/user_service.dart';
import 'package:rando/data/theme/theme_bloc.dart';
import 'package:rando/data/theme/theme_state.dart';
import 'package:rando/pages/profile/data/profile_bloc.dart';
import 'package:rando/pages/profile/data/profile_event.dart';
import 'firebase_options.dart';

// utils
import 'package:rando/config/routes.dart';

// env for security
import 'package:flutter_dotenv/flutter_dotenv.dart';

// pages
import 'package:rando/pages/reroutes/page_not_found.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // initialize flutterfire
      future: _initialization,
      builder: (context, snapshot) {
        // error loading firebase
        if (snapshot.hasError) {
          return const Text('error', textDirection: TextDirection.ltr);
        }

        // firebase loading complete
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => ThemeBloc()),
              BlocProvider(
                create: (context) {
                  final authService = AuthService();
                  final profileBloc = ProfileBloc(UserService(), authService);
                  // Trigger LoadProfile event if user is logged in
                  final currentUser = authService.user;
                  if (currentUser != null) {
                    profileBloc.add(LoadProfile(currentUser.uid));
                  }
                  return profileBloc;
                },
              ),
            ],
            child: BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                return MaterialApp(
                  onUnknownRoute: (settings) {
                    return MaterialPageRoute(
                      builder: (context) => const PageNotFoundScreen(),
                    );
                  },
                  navigatorKey: navigatorKey,
                  debugShowCheckedModeBanner: false,
                  routes: appRoutes,
                  theme: state.themeData,
                );
              },
            ),
          );
        }

        // loading firebase
        return const CircularProgressIndicator();
      },
    );
  }
}
