import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Habit Tracker',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Habit Tracker'),
        ),
        body: const Center(
          child: Text(
            'Project Started',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}