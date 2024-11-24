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
                  color: Theme.of(context).textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: FriendStrings.friends,
                    style: TextStyle(
                      color: Theme.of(context).subtextColor,
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
                  color: Theme.of(context).textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: FriendStrings.friends,
                    style: TextStyle(
                      color: Theme.of(context).subtextColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          }
          return const PrimaryText(text: DataStrings.empty);
        },
      ),
    );
  }
}
