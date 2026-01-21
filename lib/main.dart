import 'package:flutter/material.dart';
import 'package:gk_http_client/screens/home_screen.dart';

void main() {
  runApp(Apllication());
}

class Apllication extends StatelessWidget {
  const Apllication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GK - Http Client',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
