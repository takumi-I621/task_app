// lib/models/task.dart

class Task {
  final String name; // タスクの名前
  late final bool isCompleted; // タスクの完了状態
  final String category; // タスクのカテゴリ

  Task({
    required this.name,
    required this.isCompleted,
    required this.category, required int priority,
  });
}