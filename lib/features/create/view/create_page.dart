import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/create/cubit/create_cubit.dart';
import 'package:surfbored/features/create/view/create_view.dart';
import 'package:tag_repository/tag_repository.dart';

class CreatePage extends StatelessWidget {
  const CreatePage({super.key});

  static MaterialPage<void> page() {
    return const MaterialPage<void>(child: CreatePage());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: CustomPageView(
        top: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const AppBarText(text: AppStrings.createPage),
        ),
        body: BlocProvider(
          create: (context) => CreateCubit(
            postRepository: context.read<PostRepository>(),
            boardRepository: context.read<BoardRepository>(),
            tagRepository: context.read<TagRepository>(),
          ),
          child: BlocBuilder<CreateCubit, CreateState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.isCreated) {
                return const Center(
                  child: PrimaryText(text: AppStrings.createSuccess),
                );
              } else if (state.isEmpty) {
                return const Center(
                  child: PrimaryText(text: AppStrings.emptyPost),
                );
              } else if (state.isFailure) {
                return const Center(
                  child: PrimaryText(text: AppStrings.fetchFailure),
                );
              } else {
                return const CreatePageView();
              }
            },
          ),
        ),
      ),
    );
  }
}
