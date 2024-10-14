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
        TitleText(
          text: board.title,
          fontSize: 24,
          maxLines: 2,
        ),
        DescriptionText(text: board.description),
        const VerticalSpacer(),
        UserDetails(id: board.creatorId),
      ],
    );
  }
}
