import 'package:app_ui/app_ui.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    required this.text,
    required this.style,
    this.fontSize,
    this.maxLines,
    this.alignment,
    this.color,
    this.bold = false,
    this.autoSize = false,
    super.key,
  });

  final int? color;
  final String text;
  final double? fontSize;
  final TextStyle style;
  final int? maxLines;
  final TextAlign? alignment;
  final bool bold;
  final bool autoSize;

  @override
  Widget build(BuildContext context) {
    final colorOptions = <Color>[
      context.theme.textColor,
      context.theme.subtextColor,
      context.theme.hintTextColor,
      context.theme.inverseTextColor,
      context.theme.accentColor,
    ];
    final textStyle = style.copyWith(
      color: colorOptions[color ?? 0],
      fontSize: fontSize,
    );
    return autoSize
        ? AutoSizeText(
            text,
            style: textStyle,
            maxLines: maxLines ?? 1,
            textAlign: alignment,
            overflow: TextOverflow.ellipsis,
          )
        : Text(
            text,
            style: textStyle,
            maxLines: maxLines ?? 1,
            textAlign: alignment,
            overflow: TextOverflow.ellipsis,
          );
  }
}

// class WarningText extends StatelessWidget {
//   const WarningText({
//     required this.text,
//     required this.style,
//     required this.value,
//     this.maxLines,
//     this.alignment,
//     this.bold = false,
//     this.autoSize = false,
//     super.key,
//   });

//   final int value;
//   final String text;
//   final TextStyle style;
//   final int? maxLines;
//   final TextAlign? alignment;
//   final bool bold;
//   final bool autoSize;

//   @override
//   Widget build(BuildContext context) {
//     final textStyle = style.copyWith(
//       color: context.theme.dangerLevelColors[value],
//     );
//     return autoSize
//         ? AutoSizeText(
//             text,
//             style: textStyle,
//             maxLines: maxLines,
//             textAlign: alignment,
//           )
//         : Text(
//             text,
//             style: textStyle,
//             maxLines: maxLines,
//             textAlign: alignment,
//           );
//   }
// }

TextStyle get appBarText => CustomTextStyle.appBar;
TextStyle get titleText => CustomTextStyle.title;
TextStyle get primaryText => CustomTextStyle.primary;
TextStyle get secondaryText => CustomTextStyle.secondary;
TextStyle get buttonText => CustomTextStyle.button;
TextStyle get userText => CustomTextStyle.user;

class CustomTextStyle {
  static const appBar = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 28,
    letterSpacing: 0.3,
    overflow: TextOverflow.ellipsis,
  );

  static const title = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    letterSpacing: 0.3,
    overflow: TextOverflow.ellipsis,
  );

  static const primary = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.3,
    overflow: TextOverflow.ellipsis,
  );

  static const secondary = TextStyle(
    fontSize: 14,
    letterSpacing: 0.3,
    overflow: TextOverflow.ellipsis,
  );

  static const button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.3,
    overflow: TextOverflow.ellipsis,
  );

  static const user = TextStyle(
    fontSize: 18,
    letterSpacing: 0.3,
    overflow: TextOverflow.ellipsis,
  );
}
