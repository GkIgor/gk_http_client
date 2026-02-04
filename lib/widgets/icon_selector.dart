import 'package:flutter/material.dart';

class IconSelector extends StatelessWidget {
  const IconSelector({super.key});

  static const Map<String, IconData> icons = {
    'bolt': Icons.bolt,
    'folder': Icons.folder,
    'api': Icons.api,
    'security': Icons.security,
    'analytics': Icons.analytics,
  };

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 16,
      children: [
        for (final entry in icons.entries)
          IconButton(
            icon: Icon(entry.value),
            onPressed: () {
              // TODO: Implement icon selection
            },
          ),
      ],
    );
  }
}
