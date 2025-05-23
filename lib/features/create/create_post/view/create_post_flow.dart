import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/create/create_post/view/create_post_page.dart';
import 'package:surfbored/features/create/create_post/view/post_preview.dart';
import 'package:surfbored/features/create/create_post/view/upload_post_image.dart';
import 'package:surfbored/features/create/cubit/create_cubit.dart';
import 'package:surfbored/features/create/helpers/create_flow_controller.dart';
import 'package:surfbored/features/create/helpers/navigator_widget.dart';
import 'package:surfbored/features/error_page.dart';
import 'package:surfbored/features/loading_page.dart';
import 'package:tag_repository/tag_repository.dart';

class CreatePostFlow extends StatelessWidget {
  const CreatePostFlow({super.key});

  static MaterialPage<void> page() =>
      const MaterialPage<void>(child: CreatePostFlow());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateCubit(
        postRepository: context.read<PostRepository>(),
        boardRepository: context.read<BoardRepository>(),
        tagRepository: context.read<TagRepository>(),
      ),
      child: BlocBuilder<CreateCubit, CreateState>(
        builder: (context, state) {
          if (state.isFailure) return const ErrorPage();
          if (state.isLoading) return const LoadingPage();
          return ListenableProvider(
            create: (_) => CreateFlowController(),
            child: const CreatePostPages(),
          );
        },
      ),
    );
  }
}

class CreatePostPages extends StatelessWidget {
  const CreatePostPages({super.key});

  @override
  Widget build(BuildContext context) {
    final createFlowController = context.watch<CreateFlowController>();
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: CustomPageView(
        title: context.l10n.create,
        body: Stack(
          children: [
            PageView(
              controller: createFlowController,
              children: const [
                UploadPostImage(),
                CreatePostPage(),
                PostPreview(),
              ],
            ),
            CreateFlowNavigator(
              controller: createFlowController,
              alignment: 0.9,
            ),
          ],
        ),
      ),
    );
  }
}
