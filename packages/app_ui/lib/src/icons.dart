import 'package:app_ui/src/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Icon defaultIconStyle(BuildContext context, IconData icon) {
  return Icon(
    icon,
    color: Theme.of(context).textColor,
    size: 14,
  );
}

Icon accentIconStyle(BuildContext context, IconData icon) {
  return Icon(
    icon,
    color: Theme.of(context).accentColor,
    size: 14,
  );
}

Icon surfaceIconStyle(BuildContext context, IconData icon) {
  return Icon(
    icon,
    color: Theme.of(context).surfaceColor,
    size: 14,
  );
}

Icon selectionIconStyle(BuildContext context, IconData icon) {
  return Icon(
    icon,
    color: Theme.of(context).surfaceColor,
    size: 40,
  );
}

class AppIcons {
  // buttons
  static const IconData settings = FontAwesomeIcons.gear;
  static const IconData share = FontAwesomeIcons.share;
  static const IconData cancel = FontAwesomeIcons.xmark;
  static const IconData message = FontAwesomeIcons.paperPlane;
  static const IconData more = FontAwesomeIcons.ellipsis;
  static const IconData comment = FontAwesomeIcons.comment;
  static const IconData camera = FontAwesomeIcons.camera;
  static const IconData delete = FontAwesomeIcons.trash;
  static const IconData edit = FontAwesomeIcons.pencil;
  static const IconData block = FontAwesomeIcons.userLock;

  // toggles
  static const IconData saved = FontAwesomeIcons.solidBookmark;
  static const IconData notSaved = FontAwesomeIcons.bookmark;
  static const IconData liked = FontAwesomeIcons.solidHeart;
  static const IconData notLiked = FontAwesomeIcons.heart;
  static const IconData checked = FontAwesomeIcons.solidSquareCheck;
  static const IconData notChecked = FontAwesomeIcons.squareCheck;

  // misc
  static const IconData activity = FontAwesomeIcons.mountain;
  static const IconData posts = FontAwesomeIcons.images;
  static const IconData boards = FontAwesomeIcons.list;

  // pages
  static const IconData home = FontAwesomeIcons.house;
  static const IconData search = FontAwesomeIcons.magnifyingGlass;
  static const IconData create = FontAwesomeIcons.plus;
  static const IconData inbox = FontAwesomeIcons.inbox;
  static const IconData user = FontAwesomeIcons.solidUser;
}
