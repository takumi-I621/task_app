// Taskクラスにpriorityプロパティを追加し、Comparableを実装する
class Task implements Comparable<Task> {
  final String name;
  bool isCompleted; // late修飾子を削除
  final int priority; // 優先順位を表すプロパティ

  Task({
    required this.name,
    this.isCompleted = false, // デフォルトの初期値を設定
    required this.priority,
  });

  // compareToメソッドをオーバーライドして優先順位で比較する
  @override
  int compareTo(Task other) {
    return priority.compareTo(other.priority);
  }
}
