import 'package:flutter/material.dart';
import 'package:rando/app/cubit/app_cubit.dart';
import 'package:rando/features/home/home.dart';
import 'package:rando/features/inbox/inbox.dart';
import 'package:rando/features/login/login.dart';
import 'package:rando/features/profile/profile/profile.dart';
import 'package:rando/features/registration/register_user.dart';
import 'package:rando/features/search/search.dart';

List<Page<dynamic>> generateAppPages(
  AppState state,
  List<Page<dynamic>> pages,
) {
  switch (state.status) {
    case AppStatus.unauthenticated:
      return [LoginPage.page()];
    case AppStatus.newlyAuthenticated:
      return [HomePage.page()];
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.needsRegistration:
      return [RegisterUser.page()];
    case AppStatus.home:
      return [HomePage.page()];
    case AppStatus.search:
      return [SearchPage.page()];
    case AppStatus.create:
    // do nothing
    case AppStatus.inbox:
      return [InboxPage.page()];
    case AppStatus.profile:
      return [ProfilePage.page(userID: state.parameters['userID'] as String)];
    case AppStatus.failure:
      return [LoginPage.page()];
  }
}
