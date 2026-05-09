import 'package:flutter/material.dart';

import '../models/habit_model.dart';
import '../services/firestore_service.dart';

class HabitProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<HabitModel> _habits = [];

  List<HabitModel> get habits => _habits;

  void listenToHabits() {
    _firestoreService.getHabits().listen((habitList) {
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