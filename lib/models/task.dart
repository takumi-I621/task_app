// lib/models/task.dart

class Task {
  final String name;
  bool isCompleted; // late修飾子を削除し、通常の初期化に変更
  final String? category;

  Task({
    required this.name,
    required this.isCompleted, // late修飾子を削除し、通常の初期化に変更
    this.category, required int priority,
  });
}