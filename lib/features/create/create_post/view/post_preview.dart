import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/create/cubit/create_cubit.dart';
import 'package:surfbored/features/images/view/image_preview.dart';
import 'package:surfbored/features/tags/tags.dart';
import 'package:user_repository/user_repository.dart';

class PostPreview extends StatelessWidget {
  const PostPreview._();
  static MaterialPage<dynamic> page() => const MaterialPage<void>(
        key: ValueKey('post_preview'),
        child: PostPreview._(),
      );
  @override
  Widget build(BuildContext context) {
    final post = context.read<CreateCubit>().state.post;
    final image = context.read<CreateCubit>().state.image;
    return CustomPageView(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const AppBarText(text: AppStrings.confirmCreatePage),
      ),
      top: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            TitleText(text: post.title),
            const VerticalSpacer(),
            DescriptionText(text: post.description),
            const VerticalSpacer(),
            TagList(tags: post.tags.split('+')),
            const VerticalSpacer(multiple: 3),
            ActionButton(
              text: AppStrings.next,
              onTap: () {
                context.read<CreateCubit>().sumbitPost(
                      userId: context.read<UserRepository>().user.uuid,
                    );
                context.showSnackBar(AppStrings.success);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
