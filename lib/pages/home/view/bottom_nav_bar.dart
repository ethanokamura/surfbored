import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:rando/pages/boards/create_board/create_board.dart';
import 'package:rando/pages/posts/create_post/create_post.dart';

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
      items: const [
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.house, size: 20),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.magnifyingGlass, size: 20),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.plus, size: 20),
          label: 'Create',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.inbox, size: 20),
          label: 'Inbox',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.user, size: 20),
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
        Text(
          'Create Something:',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: currentContext.theme.textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const VerticalSpacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ActionIconButton(
              icon: FontAwesomeIcons.mountain,
              label: 'Activity',
              inverted: true,
              size: 40,
              onTap: () {
                choice = 'items';
                Navigator.pop(currentContext);
              },
            ),
            const SizedBox(width: 40),
            ActionIconButton(
              icon: FontAwesomeIcons.list,
              label: 'Board',
              inverted: true,
              size: 40,
              onTap: () {
                choice = 'boards';
                Navigator.pop(currentContext);
              },
            ),
          ],
        ),
      ],
    );
    if (choice == null) {
      return;
    } else {
      if (currentContext.mounted) {
        choice! == 'items'
            ? await Navigator.push(
                currentContext,
                MaterialPageRoute<Page<dynamic>>(
                  builder: (context) => const CreatePostPage(),
                ),
              )
            : await Navigator.push(
                currentContext,
                MaterialPageRoute<Page<dynamic>>(
                  builder: (context) => const CreateBoardPage(),
                ),
              );
      }
    }
  }
}
