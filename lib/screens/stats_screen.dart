import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/habit_provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habitProvider = context.watch<HabitProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Всего привычек: ${habitProvider.totalCount}'),
            const SizedBox(height: 12),
            Text('Выполнено: ${habitProvider.completedCount}'),
            const SizedBox(height: 12),
            Text(
              'Не выполнено: ${habitProvider.totalCount - habitProvider.completedCount}',
            ),
          ],
        ),
      ),
    );
  }
}