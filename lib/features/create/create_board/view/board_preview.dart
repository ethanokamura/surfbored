import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/create/cubit/create_cubit.dart';
import 'package:surfbored/features/images/view/image_preview.dart';
import 'package:user_repository/user_repository.dart';

class BoardPreview extends StatelessWidget {
  const BoardPreview({super.key});
  static MaterialPage<dynamic> page() => const MaterialPage<void>(
        child: BoardPreview(),
      );

  @override
  Widget build(BuildContext context) {
    final state = context.read<CreateCubit>().state;
    return state.title.isEmpty
        ? CustomText(
            text: context.l10n.invalidPost,
            maxLines: 3,
            style: titleText,
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                CustomText(
                  text: context.l10n.confirmCreatePage,
                  style: titleText,
                ),
                const VerticalSpacer(),
                if (state.image != null)
                  Center(
                    child: ImagePreview(
                      image: state.image!.readAsBytesSync(),
                      width: 256,
                      borderRadius: defaultBorderRadius,
                      aspectX: 4,
                      aspectY: 3,
                    ),
                  ),
                const VerticalSpacer(),
                CustomText(
                  text: state.title,
                  style: titleText,
                ),
                const VerticalSpacer(),
                CustomText(text: state.description, style: primaryText),
                const VerticalSpacer(multiple: 3),
                CustomButton(
                  color: 2,
                  text: context.l10n.next,
                  onTap: () {
                    context.read<CreateCubit>().sumbitBoard(
                          userId: context.read<UserRepository>().user.uuid,
                        );
                    context.showSnackBar(context.l10n.success);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
  }
}
