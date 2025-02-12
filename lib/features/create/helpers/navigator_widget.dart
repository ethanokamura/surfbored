import 'package:app_ui/app_ui.dart';

class CreateFlowNavigator extends StatelessWidget {
  const CreateFlowNavigator({
    required this.controller,
    required this.alignment,
    super.key,
  });
  final PageController controller;
  final double alignment;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, alignment),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomButton(
            onTap: () => controller.previousPage(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeIn,
            ),
            icon: AppIcons.back,
          ),
          const HorizontalSpacer(multiple: 3),
          SmoothPageIndicator(
            controller: controller,
            count: 3,
            effect: WormEffect(
              dotColor: context.theme.colorScheme.primary,
              activeDotColor: context.theme.accentColor,
            ),
          ),
          const HorizontalSpacer(multiple: 3),
          CustomButton(
            onTap: () => controller.nextPage(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeIn,
            ),
            icon: AppIcons.next,
          ),
        ],
      ),
    );
  }
}
