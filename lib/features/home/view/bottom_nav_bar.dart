import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:surfbored/features/create/create.dart';

enum NavBarItem { home, search, create, inbox, profile }

extension NavBarItemExtensions on NavBarItem {
  bool get isHome => this == NavBarItem.home;
  bool get isCreate => this == NavBarItem.create;
}

final class NavBarController extends PageController {
  NavBarController({NavBarItem initialItem = NavBarItem.home})
      : _notifier = ValueNotifier<NavBarItem>(initialItem),
        super(initialPage: initialItem.index) {
    _notifier.addListener(_listener);
  }

  final ValueNotifier<NavBarItem> _notifier;

  NavBarItem get item => _notifier.value;
  set item(NavBarItem newItem) => _notifier.value = newItem;

  void _listener() {
    jumpToPage(item.index);
  }

  @override
  void dispose() {
    _notifier
      ..removeListener(_listener)
      ..dispose();
    super.dispose();
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final navBarController = context.watch<NavBarController>();
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (index) async {
        if (NavBarItem.values[index].isCreate) {
          await showCreateModal(context);
        } else {
          navBarController.item = NavBarItem.values[index];
        }
      },
      currentIndex: context
          .select((NavBarController controller) => controller.item.index),
      selectedItemColor: Theme.of(context).accentColor,
      backgroundColor: Theme.of(context).colorScheme.surface,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(AppIcons.home, size: 20),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(AppIcons.search, size: 20),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(AppIcons.create, size: 20),
          label: 'Create',
        ),
        BottomNavigationBarItem(
          icon: Icon(AppIcons.inbox, size: 20),
          label: 'Inbox',
        ),
        BottomNavigationBarItem(
          icon: Icon(AppIcons.user, size: 20),
          label: 'Profile',
        ),
      ],
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ActionIconButton(
                  icon: AppIcons.posts,
                  inverted: true,
                  onTap: () {
                    choice = 'Post';
                    Navigator.pop(currentContext);
                  },
                ),
                const VerticalSpacer(),
                const PrimaryText(text: AppStrings.activity),
              ],
            ),
            const SizedBox(width: 40),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ActionIconButton(
                  icon: AppIcons.boards,
                  inverted: true,
                  onTap: () {
                    choice = 'Board';
                    Navigator.pop(currentContext);
                  },
                ),
                const VerticalSpacer(),
                const PrimaryText(text: AppStrings.board),
              ],
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
