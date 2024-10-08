import 'package:api_client/api_client.dart';
import 'package:app_core/app_core.dart';
import 'package:board_repository/board_repository.dart';
import 'package:comment_repository/comment_repository.dart';
import 'package:friend_repository/friend_repository.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/app/app.dart';
import 'package:surfbored/firebase_options.dart';
import 'package:tag_repository/tag_repository.dart';
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
            realtimeClientOptions: const RealtimeClientOptions(
              logLevel: RealtimeLogLevel.error,
            ),
          );
          await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          );
        } catch (e) {
          throw Exception('Database initialization error: $e');
        }
      },
      builder: () async {
        // ? initialize production dependencies
        final userRepository = UserRepository();
        await userRepository.getOpeningUser();
        final boardRepository = BoardRepository();
        final postRepository = PostRepository();
        final commentRepository = CommentRepository();
        final tagRepository = TagRepository();
        final friendRepository = FriendRepository();
        return App(
          userRepository: userRepository,
          boardRepository: boardRepository,
          postRepository: postRepository,
          commentRepository: commentRepository,
          tagRepository: tagRepository,
          friendRepository: friendRepository,
        );
      },
    );
  } catch (e) {
    throw Exception('Bootstrap error: $e');
  }
}
