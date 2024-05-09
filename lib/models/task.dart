// models/task.dart

class Task {
  final String name;
  bool isCompleted;
  final int priority;
  final String category; // カテゴリ情報を追加

  Task({
    required this.name,
    this.isCompleted = false,
    required this.priority,
    required this.category, // カテゴリ情報を受け取るように修正
  });
}
