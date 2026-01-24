import 'package:flutter/material.dart';

class EmptyRequestEditor extends StatelessWidget {
  const EmptyRequestEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        color: const Color(0xFF1E1E1E),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bolt, size: 64, color: Colors.white10),
              SizedBox(height: 16),
              Text(
                'Selecione uma requisição para editar',
                style: TextStyle(color: Colors.white54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
