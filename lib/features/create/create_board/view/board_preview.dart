import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:surfbored/features/create/cubit/create_cubit.dart';
import 'package:surfbored/features/images/view/image_preview.dart';
import 'package:user_repository/user_repository.dart';

class BoardPreview extends StatelessWidget {
  const BoardPreview._();
  static MaterialPage<dynamic> page() => const MaterialPage<void>(
        key: ValueKey('board_preview'),
        child: BoardPreview._(),
      );

  @override
  Widget build(BuildContext context) {
    final board = context.read<CreateCubit>().state.board;
    final image = context.read<CreateCubit>().state.image;
    return CustomPageView(
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (image != null)
              Center(
                child: ImagePreview(
                  image: image.readAsBytesSync(),
                  width: 256,
                  borderRadius: defaultBorderRadius,
                  aspectX: 4,
                  aspectY: 3,
                ),
              ),
            const VerticalSpacer(),
            TitleText(text: board.title),
            const VerticalSpacer(),
            PrimaryText(text: board.description),
            const VerticalSpacer(),
            ActionButton(
              onTap: () {
                context.read<CreateCubit>().sumbitBoard(
                      userId: context.read<UserRepository>().user.uuid,
                    );
                context.showSnackBar(AppLocalizations.of(context)!.success);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
