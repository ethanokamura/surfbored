import 'package:flutter/material.dart';
import 'package:rando/app/cubit/app_cubit.dart';
import 'package:rando/features/home/home.dart';
import 'package:rando/features/login/login.dart';

List<Page<dynamic>> onGenerateAppPages(
  AppStatus status,
  List<Page<dynamic>> pages,
) {
  if (status.isUnauthenticated) {
    return [LoginPage.page()];
  }
  if (status.isNewlyAuthenticated) {
    return [HomePage.page()];
  }
  return pages;
}
