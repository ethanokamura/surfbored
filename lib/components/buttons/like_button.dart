import 'package:flutter/material.dart';
import 'package:rando/utils/theme/theme.dart';

class LikeButton extends StatelessWidget {
  final bool isLiked;
  final void Function()? onTap;
  const LikeButton({
    super.key,
    required this.isLiked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked
            ? Theme.of(context).accentColor
            : Theme.of(context).backgroundColor,
      ),
    );
  }
}
