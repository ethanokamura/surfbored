import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class FriendsCountText extends StatelessWidget {
  const FriendsCountText({
    required this.friends,
    super.key,
  });
  final int friends;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: '$friends ',
        style: TextStyle(
          color: Theme.of(context).textColor,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        children: <TextSpan>[
          TextSpan(
            text: AppStrings.friends,
            style: TextStyle(
              color: Theme.of(context).subtextColor,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
