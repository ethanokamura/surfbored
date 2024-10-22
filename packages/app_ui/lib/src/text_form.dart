import 'package:app_ui/app_ui.dart';

InputDecoration defaultTextFormFieldDecoration({
  required BuildContext context,
  required String label,
  String? prefix,
}) =>
    InputDecoration(
      prefixText: prefix,
      prefixStyle: const TextStyle(fontSize: 22),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
      ),
      labelStyle: TextStyle(
        color: context.theme.subtextColor,
        fontSize: 22,
      ),
      label: Text(label),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: context.theme.subtextColor,
          width: 2,
        ),
      ),
    );

TextFormField customTextFormField({
  required BuildContext context,
  required String label,
  required TextEditingController controller,
  required int maxLength,
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
      minLines: 1,
      maxLines: 5,
      maxLength: maxLength,
      style: const TextStyle(fontSize: 22),
      decoration: defaultTextFormFieldDecoration(
        context: context,
        label: label,
        prefix: prefix,
      ),
    );
