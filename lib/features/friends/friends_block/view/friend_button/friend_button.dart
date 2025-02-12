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
              final buttonText = _getButtonText(context, state.friendStatus);
              return state.friendStatus != FriendStatus.requested
                  ? CustomButton(
                      color: 2,
                      horizontal: defaultPadding,
                      onTap: () => context
                          .read<FriendButtonCubit>()
                          .friendStateSelection(userId),
                      text: buttonText,
                    )
                  : CustomButton(
                      horizontal: defaultPadding,
                      onTap: () => context
                          .read<FriendButtonCubit>()
                          .friendStateSelection(userId),
                      text: buttonText,
                    );
            }
            return Center(
              child: CustomText(text: context.l10n.empty, style: primaryText),
            );
          },
        ),
      ),
    );
  }

  String _getButtonText(BuildContext context, FriendStatus status) {
    if (status == FriendStatus.requested) return context.l10n.requestSent;
    if (status == FriendStatus.recieved) return context.l10n.acceptRequest;
    if (status == FriendStatus.friends) return context.l10n.removeFriend;
    return context.l10n.addFriend;
  }
}
