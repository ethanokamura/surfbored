import 'package:api_client/api_client.dart';
import 'package:boards_repository/boards_repository.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:items_repository/items_repository.dart';
import 'package:rando/app/app.dart';
import 'package:rando/firebase_options.dart';
import 'package:user_repository/user_repository.dart';

Future<void> main() async {
  try {
    await bootstrap(
      init: () async {
        try {
          await dotenv.load();
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
        final boardsRepository = BoardsRepository();
        final itemsRepository = ItemsRepository();
        return App(
          userRepository: userRepository,
          boardsRepository: boardsRepository,
          itemsRepository: itemsRepository,
        );
      },
    );
  } catch (e) {
    throw Exception('Bootstrap error: $e');
  }
}
