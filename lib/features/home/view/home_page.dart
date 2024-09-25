import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:surfbored/features/create/create.dart';
import 'package:surfbored/features/explore/explore.dart';
import 'package:surfbored/features/home/view/bottom_nav_bar.dart';
import 'package:surfbored/features/profile/profile.dart';
import 'package:surfbored/features/search/search.dart';
import 'package:user_repository/user_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static Page<dynamic> page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (_) => NavBarController(),
      child: Scaffold(
        body: const HomeBody(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).accentColor,
          child: inverseIconStyle(context, AppIcons.create),
          onPressed: () async => showCreateModal(context),
        ),
        bottomNavigationBar: const BottomNavBar(),
      ),
    );
  }

  Future<void> showCreateModal(BuildContext currentContext) async {
    String? choice;
    await showBottomModal(
      currentContext,
      <Widget>[
        const TitleText(
          text: AppStrings.createSomething,
          fontSize: 24,
          // textAlign: TextAlign.center,
        ),
        const VerticalSpacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ActionSelectButton(
              icon: AppIcons.posts,
              label: AppStrings.activity,
              onTap: () {
                choice = 'Post';
                Navigator.pop(currentContext);
              },
            ),
            const SizedBox(width: 40),
            ActionSelectButton(
              icon: AppIcons.boards,
              label: AppStrings.board,
              onTap: () {
                choice = 'Board';
                Navigator.pop(currentContext);
              },
            ),
          ],
        ),
      ],
    );
    if (choice == null) return;
    if (currentContext.mounted) {
      await Navigator.push(
        currentContext,
        MaterialPageRoute<Page<dynamic>>(
          builder: (context) => CreatePage(type: choice!),
        ),
      );
    }
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});
  @override
  Widget build(BuildContext context) {
    final userID = context.read<UserRepository>().user.uid;
    final pageController = context.watch<NavBarController>();

    return PageView(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        const FeedPage(),
        const SearchPage(),
        ProfilePage(userID: userID),
      ],
    );
  }
}
