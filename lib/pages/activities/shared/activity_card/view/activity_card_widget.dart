import 'package:app_ui/app_ui.dart';
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
      )..getItem(itemID),
      child: BlocBuilder<ItemCubit, ItemState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isLoaded) {
            final item = state.item;
            return ItemCardView(item: item);
          } else if (state.isEmpty) {
            return const Center(child: Text('This board is empty.'));
          } else {
            return const Center(child: Text('Something went wrong'));
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
