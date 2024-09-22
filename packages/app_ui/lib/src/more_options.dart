import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/button_styles.dart';
import 'package:flutter/material.dart';

enum Options {
  manage,
  share,
  edit,
  delete,
  block,
}

class MoreCommentOptions extends StatelessWidget {
  const MoreCommentOptions({
    required this.onDelete,
    this.onSurface,
    super.key,
  });

  final bool? onSurface;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Options>(
      style: noBackgroundStyle(context),
      itemBuilder: (BuildContext context) => _buildMenuItems([
        _menuItem(
          context,
          Options.delete,
          AppIcons.delete,
          AppStrings.delete,
        ),
      ]),
      onSelected: (value) {
        if (value == Options.delete) {
          onDelete();
        }
      },
    );
  }
}

class MoreOptions extends StatelessWidget {
  const MoreOptions({
    required this.isOwner,
    required this.onDelete,
    required this.onManage,
    required this.onEdit,
    this.onSurface,
    super.key,
  });
  final bool isOwner;
  final bool? onSurface;
  final void Function() onDelete;
  final void Function() onManage;
  final void Function() onEdit;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Options>(
      style: defaultStyle(context, onSurface: onSurface),
      itemBuilder: (BuildContext context) => _buildMenuItems([
        _menuItem(
            context, Options.manage, AppIcons.boards, AppStrings.addOrRemove),
        _menuItem(context, Options.share, AppIcons.share, AppStrings.share),
        if (isOwner) ...[
          _menuItem(context, Options.edit, AppIcons.edit, AppStrings.edit),
          _menuItem(
            context,
            Options.delete,
            AppIcons.delete,
            AppStrings.delete,
          ),
        ],
      ]),
      onSelected: (value) {
        if (value == Options.manage) {
          onManage();
        } else if (value == Options.share) {
          // Handle share action
        } else if (value == Options.edit) {
          onEdit();
        } else if (value == Options.delete) {
          onDelete();
        }
      },
    );
  }
}

class MoreSearchOptions extends StatelessWidget {
  const MoreSearchOptions({
    required this.onManage,
    this.onSurface,
    super.key,
  });

  final bool? onSurface;
  final void Function() onManage;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Options>(
      style: defaultStyle(context, onSurface: onSurface),
      itemBuilder: (BuildContext context) => _buildMenuItems([
        _menuItem(
            context, Options.manage, AppIcons.boards, AppStrings.addOrRemove),
        _menuItem(context, Options.share, AppIcons.share, AppStrings.share),
      ]),
      onSelected: (value) {
        if (value == Options.manage) {
          onManage();
        } else if (value == Options.share) {
          // Handle share action
        }
      },
    );
  }
}

class MoreProfileOptions extends StatelessWidget {
  const MoreProfileOptions({
    required this.isCurrent,
    required this.onEdit,
    required this.onBlock,
    required this.onShare,
    this.onSurface,
    super.key,
  });

  final bool isCurrent;
  final bool? onSurface;
  final void Function() onEdit;
  final void Function() onBlock;
  final void Function() onShare;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Options>(
      style: noBackgroundStyle(context),
      itemBuilder: (BuildContext context) => _buildMenuItems([
        _menuItem(context, Options.share, AppIcons.share, AppStrings.share),
        if (isCurrent)
          _menuItem(
            context,
            Options.edit,
            AppIcons.settings,
            AppStrings.edit,
          ),
        if (!isCurrent)
          _menuItem(
            context,
            Options.block,
            AppIcons.block,
            AppStrings.toggleBlock,
          ),
      ]),
      onSelected: (value) {
        if (value == Options.edit) {
          onEdit();
        } else if (value == Options.share) {
          // Handle share action
        } else if (value == Options.block) {
          onBlock();
        }
      },
    );
  }
}

PopupMenuItem<Options> _menuItem(
  BuildContext context,
  Options value,
  IconData icon,
  String text,
) {
  return PopupMenuItem<Options>(
    value: value,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        defaultIconStyle(context, icon),
        const HorizontalSpacer(),
        PrimaryText(text: text),
      ],
    ),
  );
}

List<PopupMenuEntry<Options>> _buildMenuItems(
  List<PopupMenuEntry<Options>> items,
) {
  return items;
}

class MenuItem {
  MenuItem(this.value, this.icon, this.text);
  final Options value;
  final IconData icon;
  final String text;
}
