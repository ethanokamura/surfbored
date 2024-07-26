import 'package:app_ui/app_ui.dart';
import 'package:boards_repository/boards_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:items_repository/items_repository.dart';
import 'package:rando/pages/activities/activity_page/activity_page.dart';
import 'package:rando/pages/activities/cubit/activity_cubit.dart';
import 'package:user_repository/user_repository.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({required this.itemID, super.key});
  final String itemID;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ItemCubit(
        itemsRepository: context.read<ItemsRepository>(),
        userRepository: context.read<UserRepository>(),
        boardsRepository: context.read<BoardsRepository>(),
      ),
      child: FutureBuilder<Item>(
        future: context.read<ItemCubit>().fetchItem(itemID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const CustomContainer(
              inverted: false,
              horizontal: null,
              vertical: null,
              child: Text('Empty Item!'),
            );
          } else {
            final item = snapshot.data!;
            return ItemCardView(item: item);
          }
        },
      ),
    );
  }
}

class ItemCardView extends StatelessWidget {
  const ItemCardView({required this.item, super.key});
  final Item item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<dynamic>(
            builder: (context) => ActivityPage(itemID: item.id),
          ),
        );
      },
      child: CustomContainer(
        inverted: false,
        horizontal: 0,
        vertical: 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Hero(
                tag: item.photoURL!,
                child: ImageWidget(
                  photoURL: item.photoURL,
                  height: 128,
                  width: double.infinity,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).textColor,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    item.description,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).subtextColor,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // TagListWidget(tags: item.tags),
          ],
        ),
      ),
    );
  }
}
