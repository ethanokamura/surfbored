import 'package:flutter/material.dart';
import 'package:rando/app/cubit/app_cubit.dart';
import 'package:rando/pages/activities/activity_page/activity_page.dart';
import 'package:rando/pages/activities/edit_activity/edit_activity.dart';
import 'package:rando/pages/authentication/register_user.dart';
import 'package:rando/pages/boards/board/board.dart';
import 'package:rando/pages/boards/edit_board/edit_board.dart';
import 'package:rando/pages/boards/shared/add_activity/add_activity.dart';
import 'package:rando/pages/create/create.dart';
import 'package:rando/pages/home/home.dart';
import 'package:rando/pages/inbox/inbox.dart';
import 'package:rando/pages/login/login.dart';
import 'package:rando/pages/profile/edit_profile/edit_profile.dart';
import 'package:rando/pages/profile/profile/profile.dart';
import 'package:rando/pages/profile/profile_settings/profile_settings.dart';
import 'package:rando/pages/search/search.dart';

List<Page<dynamic>> generateAppPages(
  AppState state,
  List<Page<dynamic>> pages,
) {
  switch (state.status) {
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
    case AppStatus.newlyAuthenticated:
      return [RegisterUser.page()];
    case AppStatus.authenticated:
      return [HomePage.page()];
    // main routes
    case AppStatus.home:
      return [HomePage.page()];
    // search page
    case AppStatus.search:
      return [SearchPage.page()];
    // add inbox page
    case AppStatus.inbox:
      return [InboxPage.page()];
    // profile
    case AppStatus.profile:
      return [ProfilePage.page(userID: state.parameters['userID'] as String)];
    case AppStatus.profileSettings:
      return [ProfileSettingsPage.page()];
    case AppStatus.editProfile:
      return [
        EditProfilePage.page(userID: state.parameters['userID'] as String),
      ];

    // activities
    case AppStatus.activity:
      return [ActivityPage.page(itemID: state.parameters['itemID'] as String)];
    case AppStatus.editActivity:
      return [
        EditActivityPage.page(itemID: state.parameters['itemID'] as String),
      ];
    case AppStatus.addActivity:
      return [
        AddToBoardPage.page(
          itemID: state.parameters['itemID'] as String,
          userID: state.parameters['userID'] as String,
        ),
      ];
    case AppStatus.create:
      return [CreatePage.page(type: state.parameters['type'] as String)];

    // boards
    case AppStatus.board:
      return [BoardPage.page(boardID: state.parameters['boardID'] as String)];
    case AppStatus.editBoard:
      return [
        EditBoardPage.page(boardID: state.parameters['boardID'] as String)
      ];

    // Handle failure case if needed
    case AppStatus.failure:
      return [LoginPage.page()];
  }
}
