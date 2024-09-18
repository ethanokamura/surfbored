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
          icon: Icon(FontAwesomeIcons.solidUser, size: 20),
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
          text: 'Create Something:',
          fontSize: 24,
          // textAlign: TextAlign.center,
        ),
        const VerticalSpacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LabeledIconButton(
              icon: FontAwesomeIcons.mountain,
              label: 'Activity',
              inverted: true,
              size: 40,
              onTap: () {
                choice = 'Post';
                Navigator.pop(currentContext);
              },
            ),
            const SizedBox(width: 40),
            LabeledIconButton(
              icon: FontAwesomeIcons.list,
              label: 'Board',
              inverted: true,
              size: 40,
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
