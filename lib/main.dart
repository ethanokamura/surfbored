import 'package:api_client/api_client.dart';
import 'package:rando/app/app.dart';
import 'package:rando/firebase_options.dart';
import 'package:user_repository/user_repository.dart';

Future<void> main() async {
  try {
    await bootstrap(
      init: () async {
        try {
          // await dotenv.load();
          await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          );
        } catch (e) {
          throw Exception('Firebase initialization error: $e');
        }
      },
      builder: () async {
        // ? initialize production dependencies
        final userRepository = UserRepository();
        await userRepository.getOpeningUser();
        return App(
          userRepository: userRepository,
        );
      },
    );
  } catch (e) {
    throw Exception('Bootstrap error: $e');
  }
}
