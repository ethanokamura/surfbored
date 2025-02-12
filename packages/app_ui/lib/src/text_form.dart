import 'package:app_ui/app_ui.dart';

InputDecoration defaultTextFormFieldDecoration({
  required BuildContext context,
  required String label,
  String? hintText,
  bool? onBackground,
  String? prefix,
}) =>
    InputDecoration(
      filled: true,
      fillColor: onBackground != null && onBackground
          ? context.theme.primaryColor
          : context.theme.backgroundColor,
      prefixText: prefix,
      prefixStyle: const TextStyle(fontSize: 16),
      hintText: hintText,
      hintStyle: secondaryText,
      hintMaxLines: 1,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
      ),
      labelStyle: const TextStyle(
        fontSize: 16,
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(defaultRadius),
          bottomLeft: Radius.circular(defaultRadius),
        ),
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(defaultRadius),
          bottomLeft: Radius.circular(defaultRadius),
        ),
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
      ),
      label: Text(label),
    );

TextFormField customTextFormField({
  required BuildContext context,
  required String label,
  required TextEditingController controller,
  bool? onBackground,
  bool autofocus = false,
  String? prefix,
  int? maxLength,
  TextInputType? keyboardType,
  bool? obscureText,
  String? hintText,
  void Function(String)? onChanged,
  String? Function(String?)? validator,
}) =>
    TextFormField(
      controller: controller,
      obscureText: obscureText ?? false,
      onChanged: onChanged,
      keyboardType: keyboardType,
      validator: validator,
      minLines: 1,
      maxLines: 5,
      maxLength: maxLength,
      cursorColor: context.theme.hintTextColor,
      autofocus: autofocus,
      style: const TextStyle(fontSize: 16),
      decoration: defaultTextFormFieldDecoration(
        onBackground: onBackground,
        context: context,
        hintText: hintText,
        label: label,
        prefix: prefix,
      ),
    );

InputDecoration searchTextFormFieldDecoration({
  required BuildContext context,
  required String label,
  IconData? icon,
}) =>
    InputDecoration(
      prefixIcon: icon != null ? defaultIconStyle(context, icon, 0) : null,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
      ),
      label: CustomText(text: label, style: secondaryText),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 0,
        ),
      ),
    );

TextFormField searchTextFormField({
  required BuildContext context,
  required String label,
  required TextEditingController controller,
  void Function(String)? onChanged,
  String? Function(String?)? validator,
  IconData? icon,
}) =>
    TextFormField(
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      minLines: 1,
      style: const TextStyle(fontSize: 18),
      decoration: searchTextFormFieldDecoration(
        context: context,
        label: label,
        icon: icon,
      ),
    );
