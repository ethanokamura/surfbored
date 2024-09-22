import 'package:app_ui/app_ui.dart';
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
      style: _noBackgroundStyle(context, onSurface),
      itemBuilder: (BuildContext context) => _buildMenuItems([
        _menuItem(
          Options.delete,
          Icons.delete_outline_outlined,
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
      style: _menuStyle(context, onSurface),
      itemBuilder: (BuildContext context) => _buildMenuItems([
        _menuItem(Options.manage, Icons.list, AppStrings.addOrRemove),
        _menuItem(Options.share, Icons.ios_share, AppStrings.share),
        if (isOwner) ...[
          _menuItem(Options.edit, Icons.edit, AppStrings.edit),
          _menuItem(
            Options.delete,
            Icons.delete_outline_outlined,
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
      style: _menuStyle(context, onSurface),
      itemBuilder: (BuildContext context) => _buildMenuItems([
        _menuItem(Options.manage, Icons.list, AppStrings.addOrRemove),
        _menuItem(Options.share, Icons.ios_share, AppStrings.share),
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
      style: _menuStyle(context, onSurface),
      itemBuilder: (BuildContext context) => _buildMenuItems([
        _menuItem(Options.share, Icons.ios_share, AppStrings.share),
        if (isCurrent) _menuItem(Options.edit, Icons.settings, AppStrings.edit),
        if (!isCurrent)
          _menuItem(Options.block, Icons.block_flipped, AppStrings.toggleBlock),
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

PopupMenuItem<Options> _menuItem(Options value, IconData icon, String text) {
  return PopupMenuItem<Options>(
    value: value,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Icon(icon),
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

ButtonStyle _menuStyle(BuildContext context, bool? onSurface) {
  return ElevatedButton.styleFrom(
    padding: const EdgeInsets.all(defaultPadding),
    elevation: 0,
    backgroundColor: onSurface != null && onSurface
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(borderRadius: defaultBorderRadius),
  );
}

ButtonStyle _noBackgroundStyle(BuildContext context, bool? onSurface) {
  return ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}
