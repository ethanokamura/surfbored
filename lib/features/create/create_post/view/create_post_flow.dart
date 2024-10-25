import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/create/create_post/view/create_post_page.dart';
import 'package:surfbored/features/create/create_post/view/post_preview.dart';
import 'package:surfbored/features/create/create_post/view/upload_post_image.dart';
import 'package:surfbored/features/create/cubit/create_cubit.dart';
import 'package:tag_repository/tag_repository.dart';

/// Generate pages based on AppStatus
List<Page<dynamic>> onGenerateCreatePostPages(
  CreateStatus status,
  List<Page<dynamic>> pages,
) {
  if (status.isInitial) {
    return [UploadPostImage.page()];
  }
  if (status.needsDetails) {
    return [CreatePostPage.page()];
  }
  if (status.needsApproval) {
    return [PostPreview.page()];
  }
  return pages;
}

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
          if (state.isFailure) return _buildErrorScreen(context);
          if (state.isLoading) return _buildLoadingScreen();
          return FlowBuilder(
            onGeneratePages: onGenerateCreatePostPages,
            state: context.select<CreateCubit, CreateStatus>(
              (cubit) => cubit.state.status,
            ),
          );
        },
      ),
    );
  }
}

Widget _buildErrorScreen(BuildContext context) {
  return CustomPageView(
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      title: AppBarText(text: AppLocalizations.of(context)!.errorPage),
    ),
    top: false,
    body: Center(
      child: PrimaryText(text: AppLocalizations.of(context)!.unknownFailure),
    ),
  );
}

Widget _buildLoadingScreen() {
  return const Center(child: CircularProgressIndicator());
}
