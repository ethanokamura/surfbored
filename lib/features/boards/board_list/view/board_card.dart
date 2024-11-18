import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:surfbored/features/boards/boards.dart';
import 'package:surfbored/features/images/images.dart';

class BoardCard extends StatelessWidget {
  const BoardCard({required this.board, super.key});
  final Board board;

  @override
  Widget build(BuildContext context) {
    final boardCubit = context.read<BoardCubit>();
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<dynamic>(
            builder: (context) {
              return BlocProvider.value(
                value: boardCubit,
                child: BoardPage(boardId: board.id!),
              );
            },
          ),
        );
      },
      child: CustomContainer(
        child: Row(
          children: [
            ImageWidget(
              borderRadius: defaultBorderRadius,
              photoUrl: board.photoUrl,
              width: 64,
              aspectX: 1,
              aspectY: 1,
            ),
            const HorizontalSpacer(),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TitleText(text: board.title),
                  SecondaryText(text: board.description, maxLines: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
