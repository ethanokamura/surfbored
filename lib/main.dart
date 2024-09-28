import 'package:api_client/api_client.dart';
import 'package:app_core/app_core.dart';
import 'package:board_repository/board_repository.dart';
import 'package:comment_repository/comment_repository.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/app/app.dart';
import 'package:surfbored/firebase_options.dart';
import 'package:user_repository/user_repository.dart';

Future<void> main() async {
  try {
    await bootstrap(
      init: () async {
        try {
          await dotenv.load();
          await Supabase.initialize(
            url: dotenv.env['SUPABASE_URL']!,
            anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
          );
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
        final boardRepository = BoardRepository();
        final postRepository = PostRepository();
        final commentRepository = CommentRepository();
        return App(
          boardRepository: boardRepository,
          commentRepository: commentRepository,
          postRepository: postRepository,
          userRepository: userRepository,
        );
      },
    );
  } catch (e) {
    throw Exception('Bootstrap error: $e');
  }
}
