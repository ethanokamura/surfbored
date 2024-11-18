import 'package:app_ui/app_ui.dart';

enum CreateFlowPage { imageUpload, createDetails, previewPost }

final class CreateFlowController extends PageController {
  CreateFlowController({
    CreateFlowPage initialPage = CreateFlowPage.imageUpload,
  })  : _notifier = ValueNotifier<CreateFlowPage>(initialPage),
        super(initialPage: initialPage.index) {
    _notifier.addListener(_listener);
  }

  final ValueNotifier<CreateFlowPage> _notifier;

  CreateFlowPage get createPage => _notifier.value;
  set createPage(CreateFlowPage newCreatePage) =>
      _notifier.value = newCreatePage;

  void _listener() {
    jumpToPage(createPage.index);
  }

  @override
  void dispose() {
    _notifier
      ..removeListener(_listener)
      ..dispose();
    super.dispose();
  }
}
