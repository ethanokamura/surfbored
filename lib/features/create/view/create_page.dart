import 'dart:io';
import 'dart:typed_data';
import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:board_repository/board_repository.dart';
import 'package:post_repository/post_repository.dart';
import 'package:surfbored/features/create/cubit/create_cubit.dart';
import 'package:surfbored/features/tags/tags.dart';
import 'package:tag_repository/tag_repository.dart';
import 'package:user_repository/user_repository.dart';

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
                return buildCreateScreen(context);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildCreateScreen(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverSafeArea(
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                CustomTabBarWidget(
                  tabs: [
                    CustomTabWidget(
                      child: defaultIconStyle(context, AppIcons.activity),
                    ),
                    CustomTabWidget(
                      child: defaultIconStyle(context, AppIcons.boards),
                    ),
                  ],
                ),
                const VerticalSpacer(),
              ],
            ),
          ),
        ),
        const SliverFillRemaining(
          child: TabBarView(
            children: [
              CreatePost(),
              CreateBoard(),
            ],
          ),
        ),
      ],
    );
  }
}

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});
  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  // text controller
  final textController = TextEditingController();
  Uint8List? pickedImage;

  bool isLoading = false;

  String titleText = 'title';
  String descriptionText = 'description';
  String linkText = 'link';
  List<String> tags = [];
  bool isPublic = true;
  int docID = 0;
  String? photoUrl;

  File? imageFile;
  String? filename;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // upload image
        UploadImageWidget(
          width: 128,
          photoUrl: photoUrl,
          onFileChanged: (file) {
            setState(() {
              imageFile = file;
            });
          },
        ),
        const VerticalSpacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            PrimaryText(
              text: isPublic ? AppStrings.isPublic : AppStrings.isPrivate,
            ),
            const HorizontalSpacer(),
            Switch(
              value: isPublic,
              onChanged: (value) => setState(() => isPublic = value),
            ),
          ],
        ),
        const VerticalSpacer(),
        // edit title
        CustomTextBox(
          label: 'title',
          text: titleText,
          onPressed: () => editField(Post.titleConverter),
        ),
        const VerticalSpacer(),

        // edit description
        CustomTextBox(
          label: 'description',
          text: descriptionText,
          onPressed: () => editField(Post.descriptionConverter),
        ),
        const VerticalSpacer(),

        // edit link
        CustomTextBox(
          label: 'link',
          text: linkText,
          onPressed: () => editField(Post.linkConverter),
        ),
        const VerticalSpacer(),

        EditTagsBox(
          tags: tags,
          updateTags: (newTags) => setState(() {
            tags = newTags;
          }),
        ),
        const VerticalSpacer(),

        // submit
        ActionButton(
          inverted: true,
          onTap: () {
            context.read<CreateCubit>().createPost(
                  userId: context.read<UserRepository>().user.uuid,
                  title: titleText,
                  description: descriptionText,
                  link: linkText,
                  tags: tags,
                  isPublic: isPublic,
                  imageFile: imageFile,
                );
            Navigator.pop(context);
          },
          text: AppStrings.create,
        ),
      ],
    );
  }

  Future<void> editField(String field) async {
    if (field == Post.titleConverter && field != titleText) {
      textController.text = titleText;
    } else if (field == Post.descriptionConverter && field != descriptionText) {
      textController.text = descriptionText;
    } else if (field == Post.linkConverter && field != linkText) {
      textController.text = linkText;
    }

    // edit
    await editTextField(context, field, textController);

    // update field
    if (textController.text.trim().isNotEmpty) {
      setState(() {
        if (field == Post.titleConverter) {
          titleText = textController.text;
        } else if (field == Post.descriptionConverter) {
          descriptionText = textController.text;
        } else if (field == Post.linkConverter) {
          linkText = textController.text;
        }
      });
      textController.clear();
    }
  }
}

class CreateBoard extends StatefulWidget {
  const CreateBoard({super.key});
  @override
  State<CreateBoard> createState() => _CreateBoardState();
}

class _CreateBoardState extends State<CreateBoard> {
  // text controller
  final textController = TextEditingController();
  Uint8List? pickedImage;

  bool isLoading = false;

  String titleText = 'title';
  String descriptionText = 'description';
  bool isPublic = true;
  int docID = 0;
  String? photoUrl;

  File? imageFile;
  String? filename;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // upload image
        UploadImageWidget(
          width: 128,
          photoUrl: photoUrl,
          onFileChanged: (file) {
            setState(() {
              imageFile = file;
            });
          },
        ),
        const VerticalSpacer(),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            PrimaryText(
              text: isPublic ? AppStrings.isPublic : AppStrings.isPrivate,
            ),
            const HorizontalSpacer(),
            Switch(
              value: isPublic,
              onChanged: (value) => setState(() => isPublic = value),
            ),
          ],
        ),
        const VerticalSpacer(),

        // edit title
        CustomTextBox(
          label: 'title',
          text: titleText,
          onPressed: () => editField(Post.titleConverter),
        ),
        const VerticalSpacer(),

        // edit description
        CustomTextBox(
          label: 'description',
          text: descriptionText,
          onPressed: () => editField(Post.descriptionConverter),
        ),
        const VerticalSpacer(),
        // submit
        ActionButton(
          inverted: true,
          onTap: () {
            context.read<CreateCubit>().createBoard(
                  userId: context.read<UserRepository>().user.uuid,
                  title: titleText,
                  description: descriptionText,
                  isPublic: isPublic,
                  imageFile: imageFile,
                );
            Navigator.pop(context);
          },
          text: AppStrings.create,
        ),
      ],
    );
  }

  Future<void> editField(String field) async {
    if (field == Board.titleConverter && field != titleText) {
      textController.text = titleText;
    } else if (field == Board.descriptionConverter &&
        field != descriptionText) {
      textController.text = descriptionText;
    }

    // edit
    await editTextField(context, field, textController);

    // update field
    if (textController.text.trim().isNotEmpty) {
      setState(() {
        if (field == Board.titleConverter) {
          titleText = textController.text;
        } else if (field == Board.descriptionConverter) {
          descriptionText = textController.text;
        }
      });
      textController.clear();
    }
  }
}
