import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/habit_provider.dart';
import 'about_screen.dart';
import 'add_habit_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habitProvider = context.watch<HabitProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
  'Мои привычки',
  style: TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24,
  ),
),
        actions: [
          IconButton(
            icon: const Icon(
  Icons.insights_rounded,
  color: Colors.indigo,
),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StatsScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(
  Icons.info_outline_rounded,
  color: Colors.indigo,
),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AboutScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
  children: [
    Container(
  width: double.infinity,
  margin: const EdgeInsets.all(16),
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    gradient: const LinearGradient(
      colors: [
        Color(0xFF5B67F1),
        Color(0xFF7B83FF),
      ],
    ),
    borderRadius: BorderRadius.circular(24),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Habit Tracker',
        style: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        'Всего привычек: ${habitProvider.totalCount}',
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 16,
        ),
      ),
      const SizedBox(height: 12),
      LinearProgressIndicator(
        value: habitProvider.totalCount == 0
            ? 0
            : habitProvider.completedCount /
                habitProvider.totalCount,
        minHeight: 10,
        borderRadius: BorderRadius.circular(20),
      ),
    ],
  ),
),
    Padding(
      padding: const EdgeInsets.all(12),
      child: SegmentedButton<HabitFilter>(
        segments: const [
          ButtonSegment(
            value: HabitFilter.all,
            label: Text('Все'),
          ),
          ButtonSegment(
            value: HabitFilter.completed,
            label: Text('Готово'),
          ),
          ButtonSegment(
            value: HabitFilter.notCompleted,
            label: Text('Не готово'),
          ),
        ],
        selected: {habitProvider.filter},
        onSelectionChanged: (selected) {
          habitProvider.changeFilter(selected.first);
        },
      ),
    ),
    Expanded(
      child: habitProvider.habits.isEmpty
          ? const Center(
              child: Text(
                'Привычек нет',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: habitProvider.habits.length,
              itemBuilder: (context, index) {
                final habit = habitProvider.habits[index];

                return Card(
  margin: const EdgeInsets.only(bottom: 12),
  child: ListTile(
    onLongPress: () async {
      final controller = TextEditingController(
        text: habit.title,
      );

      final result = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Редактировать привычку'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Название привычки',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('Отмена'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text('Сохранить'),
              ),
            ],
          );
        },
      );

      if (result == true &&
          controller.text.trim().isNotEmpty) {
        await habitProvider.updateHabitTitle(
          habit.id,
          controller.text.trim(),
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Привычка обновлена'),
            ),
          );
        }
      }
    },
                    leading: Transform.scale(
  scale: 1.2,
  child: Checkbox(
    value: habit.isCompleted,
    activeColor: Colors.indigo,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
    ),
    onChanged: (value) async {
  await habitProvider.updateHabitStatus(
    habit.id,
    value ?? false,
  );

  final allCompleted =
      habitProvider.totalCount > 0 &&
      habitProvider.completedCount == habitProvider.totalCount;

  if (allCompleted && context.mounted) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Отлично! 🎉'),
          content: const Text(
            'Все привычки выполнены. Отличный результат!',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Спасибо'),
            ),
          ],
        );
      },
    );
  }
},
  ),
),
                    title: Text(
  habit.title,
  style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: habit.isCompleted
        ? Colors.grey
        : Colors.black87,
    decoration: habit.isCompleted
        ? TextDecoration.lineThrough
        : TextDecoration.none,
  ),
),
                    subtitle: Text(
                      '${habit.isCompleted ? 'Выполнено' : 'Не выполнено'}\n'
                      'Добавлено: '
                      '${habit.createdAt.day}.${habit.createdAt.month}.${habit.createdAt.year}',
                    ),
                    trailing: Container(
  decoration: BoxDecoration(
    color: Colors.red.withOpacity(0.1),
    borderRadius: BorderRadius.circular(12),
  ),
  child: IconButton(
    icon: const Icon(
      Icons.delete_outline,
      color: Colors.red,
    ),
    onPressed: () async {
      final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Удаление'),
            content: const Text(
              'Вы уверены, что хотите удалить привычку?',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('Отмена'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text('Удалить'),
              ),
            ],
          );
        },
      );

      if (shouldDelete == true) {
        habitProvider.deleteHabit(habit.id);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Привычка удалена'),
            ),
          );
        }
      }
    },
  ),
),
                )
                );
              },
            ),
    ),
  ],
),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddHabitScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Добавить'),
      ),
    );
  }
}