import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('О приложении'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Трекер привычек — приложение для добавления, выполнения и отслеживания привычек.\n\n'
          'Проект создан на Flutter с использованием Provider и Firebase Firestore.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}