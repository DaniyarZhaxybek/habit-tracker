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
        title: const Text('Мои привычки'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
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
            icon: const Icon(Icons.info),
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
                    leading: Checkbox(
                      value: habit.isCompleted,
                      onChanged: (value) {
                        habitProvider.updateHabitStatus(
                          habit.id,
                          value ?? false,
                        );
                      },
                    ),
                    title: Text(
                      habit.title,
                      style: TextStyle(
                        fontSize: 18,
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
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
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