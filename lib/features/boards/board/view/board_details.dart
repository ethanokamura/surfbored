import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:surfbored/features/profile/profile.dart';

class BoardDetails extends StatelessWidget {
  const BoardDetails({required this.board, super.key});
  final Board board;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: board.title,
          fontSize: 24,
          maxLines: 2,
          style: titleText,
        ),
        CustomText(
          text: board.description,
          style: secondaryText,
        ),
        const VerticalSpacer(),
        UserDetails(id: board.creatorId),
      ],
    );
  }
}
