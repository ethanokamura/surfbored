import 'package:app_ui/app_ui.dart';
import 'package:surfbored/features/create/view/create_board.dart';
import 'package:surfbored/features/create/view/create_post.dart';

class CreatePageView extends StatelessWidget {
  const CreatePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverSafeArea(
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                CustomTabBarWidget(
                  tabs: [
                    CustomTabWidget(
                      child: defaultIconStyle(context, AppIcons.activity),
                    ),
                    CustomTabWidget(
                      child: defaultIconStyle(context, AppIcons.boards),
                    ),
                  ],
                ),
                const VerticalSpacer(),
              ],
            ),
          ),
        ),
        const SliverFillRemaining(
          child: TabBarView(
            children: [
              CreatePost(),
              CreateBoard(),
            ],
          ),
        ),
      ],
    );
  }
}
