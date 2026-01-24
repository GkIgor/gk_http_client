import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gk_http_client/main.dart';

class AppConfig {
  final String _applicationName = 'gk_http_client';

  String? workspaceDir() {
    if (kIsWeb) return null;

    return '${Platform.environment['HOME']}/.$_applicationName/workspaces';
  }
}
