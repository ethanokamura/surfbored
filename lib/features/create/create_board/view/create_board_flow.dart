import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/create/create_board/view/board_preview.dart';
import 'package:surfbored/features/create/create_board/view/create_board_page.dart';
import 'package:surfbored/features/create/create_board/view/upload_board_image.dart';
import 'package:surfbored/features/create/cubit/create_cubit.dart';
import 'package:surfbored/features/create/helpers/create_flow_controller.dart';
import 'package:surfbored/features/create/helpers/navigator_widget.dart';
import 'package:surfbored/features/misc/error_page.dart';
import 'package:surfbored/features/misc/loading_page.dart';
import 'package:tag_repository/tag_repository.dart';

class CreateBoardFlow extends StatelessWidget {
  const CreateBoardFlow({super.key});

  static MaterialPage<void> page() =>
      const MaterialPage<void>(child: CreateBoardFlow());

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
            child: const CreateBoardPages(),
          );
        },
      ),
    );
  }
}

class CreateBoardPages extends StatelessWidget {
  const CreateBoardPages({super.key});

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
                UploadBoardImage(),
                CreateBoardPage(),
                BoardPreview(),
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

Widget _buildErrorScreen(BuildContext context) {
  return CustomPageView(
    title: context.l10n.errorPage,
    body: Center(
      child: PrimaryText(text: context.l10n.unknownFailure),
    ),
  );
}

Widget _buildLoadingScreen() {
  return const Center(child: CircularProgressIndicator());
}
