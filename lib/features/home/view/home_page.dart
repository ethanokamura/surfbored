import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
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
          child: inverseIconStyle(context, AppIcons.search),
          // change to go to search page or pop up search bar?
          onPressed: () async => showSearch(context),
        ),
        bottomNavigationBar: const BottomNavBar(),
      ),
    );
  }

  Future<void> showSearch(BuildContext context) async {}
}

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});
  @override
  Widget build(BuildContext context) {
    final userId = context.read<UserRepository>().user.uuid;
    final pageController = context.watch<NavBarController>();

    return PageView(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        const FeedPage(),
        const SearchPage(),
        ProfilePage(userId: userId),
      ],
    );
  }
}
