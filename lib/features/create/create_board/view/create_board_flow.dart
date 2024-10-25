import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/create/create_board/view/board_preview.dart';
import 'package:surfbored/features/create/create_board/view/create_board_page.dart';
import 'package:surfbored/features/create/create_board/view/upload_board_image.dart';
import 'package:surfbored/features/create/cubit/create_cubit.dart';
import 'package:tag_repository/tag_repository.dart';

/// Generate pages based on AppStatus
List<Page<dynamic>> onGenerateCreateBoardPages(
  CreateStatus status,
  List<Page<dynamic>> pages,
) {
  if (status.isInitial) {
    return [UploadBoardImage.page()];
  }
  if (status.needsDetails) {
    return [CreateBoardPage.page()];
  }
  if (status.needsApproval) {
    return [BoardPreview.page()];
  }
  return pages;
}

class CreateBoardFlow extends StatelessWidget {
  const CreateBoardFlow({super.key});

  static MaterialPage<void> page() =>
      const MaterialPage<void>(child: CreateBoardFlow());

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const AppBarText(text: AppStrings.createBoardPage),
      ),
      top: false,
      body: BlocProvider(
        create: (context) => CreateCubit(
          postRepository: context.read<PostRepository>(),
          boardRepository: context.read<BoardRepository>(),
          tagRepository: context.read<TagRepository>(),
        ),
        child: BlocBuilder<CreateCubit, CreateState>(
          builder: (context, state) {
            if (state.isFailure) return _buildErrorScreen();
            if (state.isLoading) return _buildLoadingScreen();
            return FlowBuilder(
              onGeneratePages: onGenerateCreateBoardPages,
              state: context.select<CreateCubit, CreateStatus>(
                (cubit) => cubit.state.status,
              ),
            );
          },
        ),
      ),
    );
  }
}

Widget _buildErrorScreen() {
  return CustomPageView(
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      title: const AppBarText(text: AppStrings.errorPage),
    ),
    top: false,
    body: const Center(
      child: PrimaryText(text: AppStrings.unknownFailure),
    ),
  );
}

Widget _buildLoadingScreen() {
  return const Center(child: CircularProgressIndicator());
}
