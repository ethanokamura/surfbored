import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/create/create.dart';

enum NavBarItem { home, create, profile }

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
      selectedItemColor: context.theme.accentColor,
      backgroundColor: context.theme.colorScheme.surface,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(AppIcons.home, size: 20),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(AppIcons.create, size: 20),
          label: 'Create',
        ),
        BottomNavigationBarItem(
          icon: Icon(AppIcons.user, size: 20),
          label: 'Profile',
        ),
      ],
    );
  }

  Future<void> showCreateModal(BuildContext context) async {
    String? choice;
    await showBottomModal(
      context,
      <Widget>[
        CustomText(text: context.l10n.create, fontSize: 24, style: titleText),
        const VerticalSpacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BottomModalButton(
              icon: AppIcons.posts,
              label: context.l10n.post,
              onTap: () async {
                choice = 'post';
                Navigator.pop(context);
              },
            ),
            const SizedBox(width: 40),
            BottomModalButton(
              icon: AppIcons.boards,
              label: context.l10n.board,
              onTap: () async {
                choice = 'board';
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
    if (!context.mounted ||
        choice == null ||
        (choice != 'post' && choice != 'board')) {
      return;
    }
    await Navigator.push(
      context,
      bottomSlideTransition(
        choice == 'post' ? const CreatePostFlow() : const CreateBoardFlow(),
      ),
    );
  }
}
