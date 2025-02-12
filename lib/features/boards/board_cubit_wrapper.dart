import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/boards/cubit/board_cubit.dart';
import 'package:surfbored/features/failures/board_failures.dart';

class BoardCubitWrapper extends StatelessWidget {
  const BoardCubitWrapper({
    required this.builder,
    super.key,
  });
  final Widget Function(BuildContext, BoardState) builder;

  @override
  Widget build(BuildContext context) {
    return listenForBoardFailures<BoardCubit, BoardState>(
      failureSelector: (state) => state.failure,
      isFailureSelector: (state) => state.isFailure,
      child: BlocBuilder<BoardCubit, BoardState>(
        builder: builder,
      ),
    );
  }
}

Widget loadingBoardState(BuildContext context) =>
    const Center(child: CircularProgressIndicator());

Widget emptyBoardState(BuildContext context) => Center(
      child: CustomText(
        text: context.l10n.empty,
        style: primaryText,
      ),
    );

Widget updatedBoardState(BuildContext context) => Center(
      child: CustomText(
        text: context.l10n.fromUpdate,
        style: primaryText,
      ),
    );

Widget errorBoardState(BuildContext context) => Center(
      child: CustomText(
        text: context.l10n.unknownFailure,
        style: primaryText,
      ),
    );
