import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:friend_repository/friend_repository.dart';
import 'package:surfbored/features/friends/friends_block/view/friend_count/cubit/friend_count_cubit.dart';

class FriendsCountText extends StatelessWidget {
  const FriendsCountText({
    required this.userId,
    super.key,
  });
  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FriendCountCubit(context.read<FriendRepository>())
        ..fetchFriendCount(userId: userId),
      child: BlocBuilder<FriendCountCubit, FriendCountState>(
        builder: (context, state) {
          if (state.isLoading) {
            return RichText(
              text: TextSpan(
                text: '0 ',
                style: TextStyle(
                  color: context.theme.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: context.l10n.friends(0),
                    style: TextStyle(
                      color: context.theme.subtextColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          } else if (state.isLoaded) {
            return RichText(
              text: TextSpan(
                text: '${state.friends} ',
                style: TextStyle(
                  color: context.theme.textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: context.l10n.friends(state.friends),
                    style: TextStyle(
                      color: context.theme.subtextColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          }
          return PrimaryText(text: context.l10n.empty);
        },
      ),
    );
  }
}
