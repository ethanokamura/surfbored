import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/create/cubit/create_cubit.dart';
import 'package:surfbored/features/images/view/image_preview.dart';
import 'package:surfbored/features/tags/tags.dart';
import 'package:user_repository/user_repository.dart';

class PostPreview extends StatelessWidget {
  const PostPreview({super.key});
  static MaterialPage<dynamic> page() =>
      const MaterialPage<void>(child: PostPreview());
  @override
  Widget build(BuildContext context) {
    final state = context.read<CreateCubit>().state;
    return state.title.isEmpty
        ? TitleText(text: context.l10n.invalidPost, maxLines: 3)
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleText(text: context.l10n.confirmCreatePage),
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
                TitleText(text: state.title),
                const VerticalSpacer(),
                DescriptionText(text: state.description),
                const VerticalSpacer(),
                TagList(tags: state.tags.split('+')),
                const VerticalSpacer(multiple: 3),
                ActionButton(
                  text: context.l10n.next,
                  onTap: () {
                    context.read<CreateCubit>().sumbitPost(
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
