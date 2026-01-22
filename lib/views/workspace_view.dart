import 'package:flutter/material.dart';

class WorkspaceView extends StatelessWidget {
  const WorkspaceView({super.key, required this.name, required this.onBack});

  final String name;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          title: Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              backgroundColor: Color(0xFF3C3F41),
            ),
          ),
        ),
        const Expanded(
          child: Center(
            child: Text(
              'Área de Requisições HTTP em breve...',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}
