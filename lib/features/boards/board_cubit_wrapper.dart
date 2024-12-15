import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/boards/cubit/board_cubit.dart';
import 'package:surfbored/features/failures/board_failures.dart';

class BoardCubitWrapper extends StatelessWidget {
  const BoardCubitWrapper({
    required this.loadedFunction,
    required this.updatedFunction,
    super.key,
  });
  final Widget Function(BuildContext, BoardState) loadedFunction;
  final void Function(BuildContext, BoardState) updatedFunction;

  @override
  Widget build(BuildContext context) {
    return listenForBoardFailures<BoardCubit, BoardState>(
      failureSelector: (state) => state.failure,
      isFailureSelector: (state) => state.isFailure,
      child: BlocBuilder<BoardCubit, BoardState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isLoaded) {
            loadedFunction(context, state);
          } else if (state.isEmpty) {
            return Center(
              child: PrimaryText(text: context.l10n.empty),
            );
          } else if (state.isDeleted || state.isUpdated) {
            updatedFunction(context, state);
            return Center(
              child: PrimaryText(text: context.l10n.fromUpdate),
            );
          } else if (state.isFailure) {
            return Center(
              child: PrimaryText(text: context.l10n.unknownFailure),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
