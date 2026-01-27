import 'dart:io';

class AppConfig {
  static const String _applicationName = 'gk_http_client';
  static String? home = Platform.environment['HOME'];
  static String workspaceDir = '$home/.$_applicationName/workspaces';

  Future<void> initializeInfrastructure() async {
    if (home == null) {
      throw Exception('HOME environment variable is not set');
    }

    final dir = Directory(workspaceDir);

    await dir.create(recursive: true);
  }
}
