import 'package:app_ui/app_ui.dart';

class AppBarText extends StatelessWidget {
  const AppBarText({
    required this.text,
    this.maxLines,
    this.fontSize,
    super.key,
  });
  final String text;
  final int? maxLines;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text.toUpperCase(),
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines ?? 1,
      style: TextStyle(
        color: context.theme.textColor,
        fontSize: fontSize ?? 28,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class TitleText extends StatelessWidget {
  const TitleText({
    required this.text,
    this.maxLines,
    this.fontSize,
    super.key,
  });
  final String text;
  final int? maxLines;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines ?? 1,
      style: TextStyle(
        color: context.theme.textColor,
        fontSize: fontSize ?? 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class PrimaryText extends StatelessWidget {
  const PrimaryText({
    required this.text,
    this.maxLines,
    this.fontSize,
    super.key,
  });
  final String text;
  final int? maxLines;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines ?? 1,
      style: TextStyle(
        color: context.theme.textColor,
        fontSize: fontSize ?? 16,
      ),
    );
  }
}

class SecondaryText extends StatelessWidget {
  const SecondaryText({
    required this.text,
    this.maxLines,
    this.fontSize,
    super.key,
  });
  final String text;
  final int? maxLines;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines ?? 1,
      style: TextStyle(
        color: context.theme.subtextColor,
        fontSize: fontSize ?? 14,
      ),
    );
  }
}

class DescriptionText extends StatelessWidget {
  const DescriptionText({
    required this.text,
    this.maxLines,
    this.fontSize,
    super.key,
  });
  final String text;
  final int? maxLines;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines ?? 4,
      style: TextStyle(
        color: context.theme.subtextColor,
        fontSize: fontSize ?? 16,
      ),
    );
  }
}

class UserText extends StatelessWidget {
  const UserText({
    required this.text,
    required this.bold,
    this.fontSize,
    this.maxLines,
    super.key,
  });
  final String text;
  final bool bold;
  final int? maxLines;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines ?? 1,
      style: TextStyle(
        color: context.theme.accentColor,
        fontSize: fontSize ?? 18,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}

class ButtonText extends StatelessWidget {
  const ButtonText({
    required this.text,
    required this.inverted,
    this.fontSize,
    super.key,
  });
  final String text;
  final bool inverted;
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color:
            inverted ? context.theme.inverseTextColor : context.theme.textColor,
        letterSpacing: 1.5,
        fontWeight: FontWeight.bold,
        fontSize: fontSize ?? 16,
      ),
    );
  }
}
