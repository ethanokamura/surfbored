import 'package:app_ui/src/constants.dart';
import 'package:app_ui/src/theme.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    required this.inverted,
    required this.onTap,
    super.key,
    this.icon,
    this.text,
    this.vertical,
    this.horizontal,
  });

  final IconData? icon;
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
      elevation: 10,
      shadowColor: Colors.black,
      backgroundColor: inverted
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
          if (text != null)
            Text(
              text!,
              style: TextStyle(
                color: inverted
                    ? Theme.of(context).inverseTextColor
                    : Theme.of(context).textColor,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
        ],
      ),
    );
  }
}

class ActionIconButton extends StatelessWidget {
  const ActionIconButton({
    required this.icon,
    required this.inverted,
    required this.onTap,
    super.key,
    this.label,
    this.size,
  });
  final IconData icon;
  final bool inverted;
  final String? label;
  final double? size;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(
      padding: const EdgeInsets.all(10),
      elevation: 10,
      shadowColor: Colors.black,
      backgroundColor: inverted
          ? Theme.of(context).accentColor
          : Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: defaultBorderRadius),
    );

    return Column(
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
        if (label != null)
          Text(
            label!,
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).textColor,
            ),
          ),
      ],
    );
  }
}

class LikeButton extends StatelessWidget {
  const LikeButton({
    required this.onTap,
    required this.likes,
    required this.isLiked,
    super.key,
  });

  final void Function()? onTap;
  final int likes;
  final bool isLiked;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked
                ? Theme.of(context).accentColor
                : Theme.of(context).backgroundColor,
          ),
          const SizedBox(width: 10),
          Text('$likes likes'),
        ],
      ),
    );
  }
}

class LinkWidget extends StatelessWidget {
  const LinkWidget({
    required this.text,
    required this.onTap,
    super.key,
  });

  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}

class CheckBox extends StatelessWidget {
  const CheckBox({
    required this.isSelected,
    required this.onTap,
    super.key,
  });
  final void Function()? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isSelected ? Icons.check_box_rounded : Icons.check_box_outline_blank,
        color: isSelected
            ? Theme.of(context).accentColor
            : Theme.of(context).backgroundColor,
      ),
    );
  }
}
