import 'package:flutter/material.dart';

class TreeItemWidget extends StatelessWidget {
  final String label;
  final int level;
  final bool isFolder;
  final bool isExpanded;
  final VoidCallback onTap;

  const TreeItemWidget({
    super.key,
    required this.label,
    this.level = 0,
    this.isFolder = false,
    this.isExpanded = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: level * 12.0), // Indentação dinâmica
      child: ListTile(
        dense: true,
        leading: Icon(
          isFolder
              ? (isExpanded
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_right)
              : Icons.description,
        ),
        title: Text(label),
        onTap: onTap,
      ),
    );
  }
}
