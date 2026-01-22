import 'package:flutter/material.dart';

enum AppRoute { home, workspace }

class NavigationService {
  static final ValueNotifier<AppRoute> currentRoute = ValueNotifier(
    AppRoute.home,
  );

  static String? selectedWorkspaceName;

  static void navigateTo(AppRoute route, {String? workspaceName}) {
    selectedWorkspaceName = workspaceName;
    currentRoute.value = route;
  }

  static void goBack() {
    selectedWorkspaceName = null;
    currentRoute.value = .home;
  }
}
