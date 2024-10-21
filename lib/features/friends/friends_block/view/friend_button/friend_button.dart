import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:friend_repository/friend_repository.dart';
import 'package:surfbored/features/failures/friend_failures.dart';
import 'package:surfbored/features/friends/friends_block/view/friend_button/cubit/friend_button_cubit.dart';

class FriendButton extends StatelessWidget {
  const FriendButton({
    required this.userId,
    super.key,
  });
  final String userId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FriendButtonCubit(context.read<FriendRepository>())
        ..fetchData(userId),
      child: listenForFriendFailures<FriendButtonCubit, FriendButtonState>(
        failureSelector: (state) => state.failure,
        isFailureSelector: (state) => state.isFailure,
        child: BlocBuilder<FriendButtonCubit, FriendButtonState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.isLoaded) {
              final buttonText = _getButtonText(state.friendStatus);
              return state.friendStatus != FriendStatus.requested
                  ? ActionButton(
                      horizontal: defaultPadding,
                      onTap: () => context
                          .read<FriendButtonCubit>()
                          .friendStateSelection(userId),
                      text: buttonText,
                    )
                  : DefaultButton(
                      horizontal: defaultPadding,
                      onTap: () => context
                          .read<FriendButtonCubit>()
                          .friendStateSelection(userId),
                      text: buttonText,
                    );
            }
            return const Center(
              child: PrimaryText(text: DataStrings.emptyFailure),
            );
          },
        ),
      ),
    );
  }

  String _getButtonText(FriendStatus status) {
    if (status == FriendStatus.requested) return FriendStrings.requestSent;
    if (status == FriendStatus.recieved) return FriendStrings.acceptRequest;
    if (status == FriendStatus.friends) return FriendStrings.removeFriend;
    return FriendStrings.addFriend;
  }
}
