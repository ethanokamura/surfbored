import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:surfbored/features/boards/saves/cubit/save_cubit.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({required this.board, required this.userId, super.key});
  final Board board;
  final String userId;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SaveCubit(context.read<BoardRepository>()),
      child: BlocBuilder<SaveCubit, SaveState>(
        builder: (context, state) {
          context.read<SaveCubit>().fetchData(board.id, userId);
          var saves = 0;
          var isSaved = false;
          if (state.isLoading) {
            // Show a loading indicator in the button if needed
          } else if (state.isSuccess) {
            saves = state.saves;
            isSaved = state.saved;
          }
          return ToggleButton(
            onSurface: false,
            onTap: () => context.read<SaveCubit>().toggleSave(
                  userId: userId,
                  boardId: board.id,
                  saved: isSaved,
                ),
            icon: isSaved
                ? accentIconStyle(context, AppIcons.saved)
                : defaultIconStyle(context, AppIcons.notSaved),
            text: '$saves ${AppStrings.saves}',
          );
        },
      ),
    );
  }
}
