// models/task.dart
// lib/models/task.dart

class Task {
  final int id; // ユニークなタスクID
  final String name;
  bool isCompleted;
  final int priority;
  final String category;
  final DateTime createdDate;

  Task({
    required this.id,
    required this.name,
    this.isCompleted = false,
    required this.priority,
    required this.category,
    required this.createdDate,
  });
}