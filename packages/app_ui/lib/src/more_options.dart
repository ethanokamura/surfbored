import 'package:app_core/app_core.dart';
import 'package:app_ui/src/button_styles.dart';
import 'package:app_ui/src/extensions.dart';
import 'package:app_ui/src/icons.dart';
import 'package:app_ui/src/text.dart';
import 'package:app_ui/src/widgets.dart';
import 'package:flutter/material.dart';

/// Keeps track of all possible options for the more options widgets
enum Options {
  manage,
  share,
  edit,
  settings,
  delete,
  block,
}

/// Action button for the UI
/// Accent colored background
/// Requires [onDelete] function to handle the deletion event
/// Optionally changes background color with [onSurface]
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
      style: clearButtonStyle(),
      itemBuilder: (BuildContext context) => _buildMenuItems([
        _menuItem(
          context,
          MenuItem(
            Options.delete,
            AppIcons.delete,
            context.l10n.delete,
          ),
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

/// Action button for the UI
/// Accent colored background
/// Requires [onDelete] function to handle the deletion event
/// Requires [onManage] function to handle the event of adding to a board
/// Requires [onEdit] function to handle the edit event
/// Optionally changes background color with [onSurface]
class MorePostOptions extends StatelessWidget {
  const MorePostOptions({
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
      style: clearButtonStyle(),
      color: context.theme.colorScheme.primary,
      itemBuilder: (BuildContext context) => _buildMenuItems([
        _menuItem(
          context,
          MenuItem(
            Options.manage,
            AppIcons.boards,
            context.l10n.addOrRemove,
          ),
        ),
        _menuItem(
          context,
          MenuItem(
            Options.share,
            AppIcons.share,
            context.l10n.share,
          ),
        ),
        if (isOwner) ...[
          _menuItem(
            context,
            MenuItem(
              Options.edit,
              AppIcons.edit,
              context.l10n.edit,
            ),
          ),
          _menuItem(
            context,
            MenuItem(
              Options.delete,
              AppIcons.delete,
              context.l10n.delete,
            ),
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

/// Action button for the UI
/// Accent colored background
/// Requires [onManage] function to handle adding posts to boards
/// Optionally changes background color with [onSurface]
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
      style: defaultButtonStyle(context, 1),
      itemBuilder: (BuildContext context) => _buildMenuItems([
        _menuItem(
          context,
          MenuItem(
            Options.manage,
            AppIcons.boards,
            context.l10n.addOrRemove,
          ),
        ),
        _menuItem(
          context,
          MenuItem(
            Options.share,
            AppIcons.share,
            context.l10n.share,
          ),
        ),
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

/// Action button for the UI
/// Accent colored background
/// Requires [onBlock] function to handle the event of blocking a user
/// Requires [onShare] function to handle sharing
/// Optionally changes background color with [onSurface]
class MoreProfileOptions extends StatelessWidget {
  const MoreProfileOptions({
    required this.onBlock,
    required this.onShare,
    this.onSurface,
    super.key,
  });

  final bool? onSurface;
  final void Function() onBlock;
  final void Function() onShare;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Options>(
      style: clearButtonStyle(),
      itemBuilder: (BuildContext context) => _buildMenuItems([
        _menuItem(
          context,
          MenuItem(
            Options.share,
            AppIcons.share,
            context.l10n.share,
          ),
        ),
        _menuItem(
          context,
          MenuItem(
            Options.block,
            AppIcons.block,
            context.l10n.blockUser,
          ),
        ),
      ]),
      onSelected: (value) {
        if (value == Options.share) {
          // Handle share action
        } else if (value == Options.block) {
          onBlock();
        }
      },
    );
  }
}

/// Action button for the UI
/// Accent colored background
/// Requires [onDelete] function to handle the deletion event
/// Requires [onEdit] function to handle the edit event
/// Optionally changes background color with [onSurface]
class MoreBoardOptions extends StatelessWidget {
  const MoreBoardOptions({
    required this.isOwner,
    required this.onDelete,
    required this.onShare,
    required this.onEdit,
    this.onSurface,
    super.key,
  });
  final bool isOwner;
  final bool? onSurface;
  final void Function() onDelete;
  final void Function() onShare;
  final void Function() onEdit;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Options>(
      style: clearButtonStyle(),
      itemBuilder: (BuildContext context) => _buildMenuItems([
        _menuItem(
          context,
          MenuItem(
            Options.manage,
            AppIcons.boards,
            context.l10n.addOrRemove,
          ),
        ),
        _menuItem(
          context,
          MenuItem(
            Options.share,
            AppIcons.share,
            context.l10n.share,
          ),
        ),
        if (isOwner) ...[
          _menuItem(
            context,
            MenuItem(
              Options.edit,
              AppIcons.edit,
              context.l10n.edit,
            ),
          ),
          _menuItem(
            context,
            MenuItem(
              Options.delete,
              AppIcons.delete,
              context.l10n.delete,
            ),
          ),
        ],
      ]),
      onSelected: (value) {
        if (value == Options.share) {
          // Handle share action
          onShare();
        } else if (value == Options.edit) {
          onEdit();
        } else if (value == Options.delete) {
          onDelete();
        }
      },
    );
  }
}

/// Generic menu item
/// Requires [context] for build context
/// Requires a [MenuItem] to hold data
PopupMenuItem<Options> _menuItem(
  BuildContext context,
  MenuItem item,
) {
  return PopupMenuItem<Options>(
    value: item.value,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        defaultIconStyle(context, item.icon, 0),
        const HorizontalSpacer(),
        CustomText(text: item.text, style: buttonText),
      ],
    ),
  );
}

/// A generic list of the possible items
/// Requires a list of menu [items]
List<PopupMenuEntry<Options>> _buildMenuItems(
  List<PopupMenuEntry<Options>> items,
) {
  return items;
}

// The menu item itself
class MenuItem {
  MenuItem(this.value, this.icon, this.text);
  final Options value;
  final IconData icon;
  final String text;
}
