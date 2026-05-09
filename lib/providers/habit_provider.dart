import 'package:flutter/material.dart';

import '../models/habit_model.dart';
import '../services/firestore_service.dart';

enum HabitFilter {
  all,
  completed,
  notCompleted,
}

class HabitProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<HabitModel> _habits = [];
  HabitFilter _filter = HabitFilter.all;

  List<HabitModel> get habits {
    if (_filter == HabitFilter.completed) {
      return _habits.where((habit) => habit.isCompleted).toList();
    }

    if (_filter == HabitFilter.notCompleted) {
      return _habits.where((habit) => !habit.isCompleted).toList();
    }

    return _habits;
  }

  HabitFilter get filter => _filter;

  void changeFilter(HabitFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  void listenToHabits() {
    _firestoreService.getHabits().listen((habitList) {

  habitList.sort(
    (a, b) => b.createdAt.compareTo(a.createdAt),
  );

  _habits = habitList;

  notifyListeners();
});
  }

  Future<void> addHabit(String title) async {
    await _firestoreService.addHabit(title);
  }

  Future<void> updateHabitStatus(String id, bool isCompleted) async {
    await _firestoreService.updateHabitStatus(id, isCompleted);
  }

  Future<void> updateHabitTitle(String id, String title) async {
  await _firestoreService.updateHabitTitle(id, title);
}

  Future<void> deleteHabit(String id) async {
    await _firestoreService.deleteHabit(id);
  }

  int get completedCount {
    return _habits.where((habit) => habit.isCompleted).length;
  }

  int get totalCount {
    return _habits.length;
  }
}