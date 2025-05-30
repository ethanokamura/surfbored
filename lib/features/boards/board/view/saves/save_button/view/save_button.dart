import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:surfbored/features/boards/board/view/saves/cubit/save_cubit.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({required this.board, required this.userId, super.key});
  final Board board;
  final String userId;
  @override
  Widget build(BuildContext context) {
    final boardId = board.id!;
    return BlocProvider(
      create: (context) => SaveCubit(context.read<BoardRepository>()),
      child: BlocBuilder<SaveCubit, SaveState>(
        builder: (context, state) {
          context.read<SaveCubit>().fetchData(boardId, userId);
          var saves = 0;
          var isSaved = false;
          if (state.isLoading) {
            // Show a loading indicator in the button if needed
          } else if (state.isSuccess) {
            saves = state.saves;
            isSaved = state.saved;
          }
          return ToggleButton(
            onTap: () => context.read<SaveCubit>().toggleSave(
                  userId: userId,
                  boardId: boardId,
                  saved: isSaved,
                ),
            icon: isSaved
                ? defaultIconStyle(context, AppIcons.saved, 3)
                : defaultIconStyle(context, AppIcons.notSaved, 0),
            text: saves.toString(),
          );
        },
      ),
    );
  }
}
