import 'package:flutter/material.dart';
import 'package:gk_http_client/core/app_config.dart';
import 'package:gk_http_client/screens/home_screen.dart';
import 'package:gk_http_client/screens/workspace_screen.dart';
import 'package:gk_http_client/services/navigation_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig appConfig = AppConfig();
  appConfig.initializeInfrastructure();

  runApp(Apllication());
}

class Apllication extends StatelessWidget {
  Apllication({super.key});

  final Map<AppRoute, Widget Function(BuildContext)> _routes = {
    AppRoute.home: (context) => const HomeScreen(),
    AppRoute.workspace: (context) =>
        WorkspaceScreen(name: NavigationService.selectedWorkspaceName ?? ''),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GK - Http Client',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ValueListenableBuilder(
        valueListenable: NavigationService.currentRoute,
        builder: (context, route, _) {
          final builder = _routes[route];
          return builder != null ? builder(context) : const SizedBox();
        },
      ),
    );
  }
}
