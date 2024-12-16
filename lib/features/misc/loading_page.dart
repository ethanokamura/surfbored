import 'package:app_ui/app_ui.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({this.message, super.key});
  final String? message;

  @override
  Widget build(BuildContext context) {
    return const CustomPageView(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
