import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({this.message, super.key});
  final String? message;

  @override
  Widget build(BuildContext context) {
    return CustomPageView(
      title: context.l10n.errorPage,
      body: Center(
        child: CustomText(
          text: message ?? context.l10n.unknownFailure,
          style: primaryText,
        ),
      ),
    );
  }
}
