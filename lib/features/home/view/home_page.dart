import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rando/features/explore/feed.dart';
import 'package:rando/features/home/view/bottom_nav_bar.dart';
import 'package:rando/features/inbox/inbox.dart';
import 'package:rando/features/profile/profile.dart';
import 'package:rando/features/search/search.dart';
import 'package:user_repository/user_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static Page<dynamic> page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (_) => NavBarController(),
      child: const Scaffold(
        body: HomeBody(),
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});
  @override
  Widget build(BuildContext context) {
    final userID = UserRepository().user.uid;
    final pageController = context.watch<NavBarController>();
    return PageView(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        const FeedPage(),
        const SearchPage(),
        const Center(child: TitleText(text: 'Create')),
        const InboxPage(),
        ProfilePage(userID: userID),
      ],
    );
  }
}
