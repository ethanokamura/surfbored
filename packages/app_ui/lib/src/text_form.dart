import 'package:app_ui/app_ui.dart';

InputDecoration defaultTextFormFieldDecoration({
  required BuildContext context,
  required String label,
  String? prefix,
}) =>
    InputDecoration(
      prefixText: prefix,
      prefixStyle: const TextStyle(fontSize: 18),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
      ),
      labelStyle: TextStyle(
        color: Theme.of(context).subtextColor,
      ),
      label: Text(label),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
    );

TextFormField customTextFormField({
  required BuildContext context,
  required String label,
  required TextEditingController controller,
  String? prefix,
  TextInputType? keyboardType,
  void Function(String)? onChanged,
  String? Function(String?)? validator,
}) =>
    TextFormField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      validator: validator,
      decoration: defaultTextFormFieldDecoration(
        context: context,
        label: label,
        prefix: prefix,
      ),
    );
