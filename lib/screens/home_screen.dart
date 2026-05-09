import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/habit_provider.dart';
import 'add_habit_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final habitProvider = context.watch<HabitProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои привычки'),
      ),
      body: habitProvider.habits.isEmpty
          ? const Center(
              child: Text('Пока привычек нет'),
            )
          : ListView.builder(
              itemCount: habitProvider.habits.length,
              itemBuilder: (context, index) {
                final habit = habitProvider.habits[index];

                return ListTile(
                  title: Text(habit.title),
                  leading: Checkbox(
                    value: habit.isCompleted,
                    onChanged: (value) {
                      habitProvider.updateHabitStatus(
                        habit.id,
                        value ?? false,
                      );
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      habitProvider.deleteHabit(habit.id);
                    },
                  ),
                );
              },
            ),
             floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddHabitScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),     
    );
  }
}