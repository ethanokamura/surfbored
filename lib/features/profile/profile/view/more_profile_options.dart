import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

enum Options {
  share,
  edit,
  block,
}

class MoreProfileOptions extends StatelessWidget {
  const MoreProfileOptions({
    required this.isCurrent,
    required this.onEdit,
    required this.onBlock,
    required this.onShare,
    super.key,
  });
  final bool isCurrent;
  final void Function() onEdit;
  final void Function() onBlock;
  final void Function() onShare;

  @override
  Widget build(BuildContext context) {
    final style = ElevatedButton.styleFrom(
      elevation: 0,
    );
    return PopupMenuButton<Options>(
      style: style,
      itemBuilder: (BuildContext context) => [
        // share
        const PopupMenuItem(
          value: Options.share,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.ios_share),
              SizedBox(width: 10),
              PrimaryText(text: AppStrings.share),
            ],
          ),
        ),
        if (isCurrent)
          const PopupMenuItem(
            value: Options.edit,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.settings),
                SizedBox(width: 10),
                PrimaryText(text: AppStrings.edit),
              ],
            ),
          ),
        // edit activity
        if (!isCurrent)
          const PopupMenuItem(
            value: Options.block,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.block_flipped),
                SizedBox(width: 10),
                PrimaryText(text: AppStrings.toggleBlock),
              ],
            ),
          ),
      ],
      onSelected: (value) {
        switch (value) {
          // share
          case Options.share:
            break;
          // settings
          case Options.edit:
            onEdit();
          // block
          case Options.block:
            onBlock();
        }
      },
    );
  }
}
