import 'package:app_ui/src/constants.dart';
import 'package:app_ui/src/text.dart';
import 'package:app_ui/src/theme.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    required this.inverted,
    required this.onTap,
    super.key,
    this.onSurface,
    this.icon,
    this.text,
    this.vertical,
    this.horizontal,
  });

  final IconData? icon;
  final bool? onSurface;
  final bool inverted;
  final String? text;
  final double? vertical;
  final double? horizontal;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(
        horizontal: horizontal == null ? 15 : horizontal!,
        vertical: vertical == null ? 10 : vertical!,
      ),
      elevation: 0,
      shadowColor: Colors.black,
      backgroundColor: onSurface != null && onSurface!
          ? Theme.of(context).colorScheme.primary
          : inverted
              ? Theme.of(context).accentColor
              : Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: defaultBorderRadius),
    );
    return ElevatedButton(
      onPressed: onTap,
      style: style,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(
              icon,
              color: inverted
                  ? Theme.of(context).inverseTextColor
                  : Theme.of(context).textColor,
              size: 18,
            ),
          if (text != null && icon != null) const SizedBox(width: 10),
          if (text != null) ButtonText(text: text!, inverted: inverted),
        ],
      ),
    );
  }
}

// class ActionIconButton extends StatelessWidget {
//   const ActionIconButton({
//     required this.icon,
//     required this.inverted,
//     required this.onTap,
//     super.key,
//     this.size,
//     this.padding,
//   });
//   final IconData icon;
//   final bool inverted;
//   final double? size;
//   final double? padding;
//   final void Function()? onTap;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Padding(
//         padding: EdgeInsets.all(padding ?? 5),
//         child: Icon(
//           icon,
//           color: inverted
//               ? Theme.of(context).accentColor
//               : Theme.of(context).textColor,
//           size: size ?? 20,
//         ),
//       ),
//     );
//   }
// }

class ActionIconButton extends StatelessWidget {
  const ActionIconButton({
    required this.icon,
    required this.inverted,
    required this.onTap,
    super.key,
    this.label,
    this.padding,
    this.size,
    this.background,
    this.onSurface,
  });
  final IconData icon;
  final bool inverted;
  final String? label;
  final bool? background;
  final bool? onSurface;
  final double? size;
  final double? padding;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(10),
      elevation: 0,
      shadowColor: Colors.black,
      backgroundColor: onSurface != null && onSurface!
          ? Theme.of(context).colorScheme.primary
          : inverted
              ? Theme.of(context).accentColor
              : Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: defaultBorderRadius),
    );

    return background != null && background! == false
        ? GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(padding ?? 5),
              child: Icon(
                icon,
                color: inverted
                    ? Theme.of(context).accentColor
                    : Theme.of(context).textColor,
                size: size ?? 20,
              ),
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: onTap,
                style: style,
                icon: Icon(
                  icon,
                  color: inverted
                      ? Theme.of(context).inverseTextColor
                      : Theme.of(context).textColor,
                  size: size ?? 15,
                ),
              ),
              if (label != null) const SizedBox(height: 5),
              if (label != null) PrimaryText(text: label!),
            ],
          );
  }
}

class CheckBox extends StatelessWidget {
  const CheckBox({
    required this.isSelected,
    super.key,
  });
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Icon(
      isSelected ? Icons.check_box_rounded : Icons.check_box_outline_blank,
      color: isSelected
          ? Theme.of(context).accentColor
          : Theme.of(context).backgroundColor,
    );
  }
}

class ToggleButton extends StatelessWidget {
  const ToggleButton({
    required this.onSurface,
    required this.onTap,
    super.key,
    this.icon,
    this.text,
  });

  final Icon? icon;
  final bool onSurface;
  final String? text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      elevation: 0,
      shadowColor: Colors.black,
      backgroundColor: onSurface
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: defaultBorderRadius),
    );
    return ElevatedButton(
      onPressed: onTap,
      style: style,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) icon!,
          if (text != null && icon != null) const SizedBox(width: 5),
          if (text != null)
            ButtonText(
              text: text!,
              inverted: false,
              fontSize: 14,
            ),
        ],
      ),
    );
  }
}
