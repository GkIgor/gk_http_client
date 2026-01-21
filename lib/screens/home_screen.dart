import 'package:flutter/material.dart';
import 'package:gk_http_client/widgets/sidebar.dart';
import 'package:gk_http_client/views/welcome_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HTTP Client - GK',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2B2B2B),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: Row(
        children: [
          const Sidebar(),
          Expanded(
            child: Container(
              color: const Color(0xFF1E1E1E),
              child: const Welcome(),
            ),
          ),
        ],
      ),
    );
  }
}
