// dart packages
import 'package:app_ui/app_ui.dart';
// import 'package:boards_repository/boards_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:rando/pages/activities/cubit/activity_cubit.dart';
import 'package:user_repository/user_repository.dart';

class EditActivityPage extends StatelessWidget {
  const EditActivityPage({required this.itemID, super.key});
  final String itemID;
  static MaterialPage<void> page({required String itemID}) {
    return MaterialPage<void>(
      child: EditActivityPage(itemID: itemID),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Item'),
      ),
      body: BlocProvider(
        create: (_) => ItemCubit(
          itemsRepository: context.read<ItemsRepository>(),
          userRepository: context.read<UserRepository>(),
          // boardsRepository: context.read<BoardsRepository>(),
        )..streamItem(itemID),
        child: BlocBuilder<ItemCubit, ItemState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.isLoaded) {
              return EditView(item: state.item);
            } else if (state.isEmpty) {
              return const Center(child: Text('This board is empty.'));
            } else {
              return const Center(child: Text('Something went wrong'));
            }
          },
        ),
      ),
    );
  }
}

class EditView extends StatelessWidget {
  const EditView({required this.item, super.key});
  final Item item;
  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      child: SingleChildScrollView(
        child: Column(
          children: [
            EditImage(
              width: 200,
              height: 200,
              photoURL: item.photoURL,
              collection: 'users',
              docID: item.uid,
              onFileChanged: (url) {
                context.read<ItemCubit>().editField(item.id, 'photoURL', url);
              },
            ),
            const VerticalSpacer(),
            CustomTextBox(
              text: item.title,
              label: 'title',
              onPressed: () async {
                final newValue = await editTextField(
                  context,
                  'title',
                  30,
                  TextEditingController(),
                );
                if (newValue != null && context.mounted) {
                  await context
                      .read<ItemCubit>()
                      .editField(item.id, 'title', newValue);
                }
              },
            ),
            const VerticalSpacer(),
            CustomTextBox(
              text: item.description,
              label: 'description',
              onPressed: () async {
                final newValue = await editTextField(
                  context,
                  'description',
                  150,
                  TextEditingController(),
                );
                if (newValue != null && context.mounted) {
                  await context
                      .read<ItemCubit>()
                      .editField(item.id, 'description', newValue);
                }
              },
            ),
            const VerticalSpacer(),
            CustomTextBox(
              text: 'tags',
              label: 'tags',
              onPressed: () async {
                final newValue = await editTextField(
                  context,
                  'tags',
                  50,
                  TextEditingController(),
                );
                if (newValue != null && context.mounted) {
                  await context
                      .read<ItemCubit>()
                      .editField(item.id, 'tags', newValue);
                }
              },
            ),
            const VerticalSpacer(),
            TagList(tags: item.tags),
          ],
        ),
      ),
    );
  }
}
