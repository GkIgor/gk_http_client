import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      color: const Color(0xFF3C3F41),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Icon(Icons.folder, color: Colors.grey),
          ),
          Icon(Icons.search, color: Colors.grey),
        ],
      ),
    );
  }
}
