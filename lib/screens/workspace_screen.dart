import 'package:flutter/material.dart';
import 'package:gk_http_client/views/sidebar_view.dart';
import 'package:gk_http_client/widgets/empty_request_editor.dart';

class WorkspaceScreen extends StatelessWidget {
  const WorkspaceScreen({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Row(
        children: [
          SidebarView(name: name),
          const EmptyRequestEditor(),
        ],
      ),
    );
  }
}
