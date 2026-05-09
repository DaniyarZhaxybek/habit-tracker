class HabitModel {
  final String id;
  final String title;
  final bool isCompleted;

  HabitModel({
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  factory HabitModel.fromMap(Map<String, dynamic> map) {
    return HabitModel(
      id: map['id'],
      title: map['title'],
      isCompleted: map['isCompleted'],
    );
  }
}