import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/habit_model.dart';

class FirestoreService {
  final CollectionReference habitsCollection =
      FirebaseFirestore.instance.collection('habits');

  Future<void> addHabit(String title) async {
    final docRef = habitsCollection.doc();

    final habit = HabitModel(
      id: docRef.id,
      title: title,
      isCompleted: false,
    );

    await docRef.set(habit.toMap());
  }

  Stream<List<HabitModel>> getHabits() {
    return habitsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return HabitModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> updateHabitStatus(String id, bool isCompleted) async {
    await habitsCollection.doc(id).update({
      'isCompleted': isCompleted,
    });
  }

  Future<void> deleteHabit(String id) async {
    await habitsCollection.doc(id).delete();
  }
}