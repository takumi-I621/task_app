// lib/models/task.dart

class Task {
  final String name;
  bool isCompleted;
  final int priority;

  Task({required this.name, required this.isCompleted, required this.priority});
}