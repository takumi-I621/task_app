// lib/providers/task_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _completedTasks = [];
  List<Task> _incompleteTasks = [];
  bool _darkMode = false;

  List<Task> get completedTasks => _completedTasks;
  List<Task> get incompleteTasks => _incompleteTasks;
  bool get darkMode => _darkMode;

  // タスクの追加メソッド
  void addTask(String name, {required String category}) {
    _incompleteTasks.add(Task(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      isCompleted: false,
      priority: _incompleteTasks.length,
      category: category,
      createdDate: DateTime.now(),
    ));
    notifyListeners();
  }

  // タスクの完了状態を切り替えるメソッド
  void toggleTask(int id) {
    Task? task = _incompleteTasks.firstWhere((t) => t.id == id, orElse: () => _completedTasks.firstWhere((t) => t.id == id));
    if (task != null) {
      task.isCompleted = !task.isCompleted;
      if (task.isCompleted) {
        _incompleteTasks.remove(task);
        _completedTasks.add(task);
      } else {
        _completedTasks.remove(task);
        _incompleteTasks.add(task);
      }
      notifyListeners();
    }
  }

  // タスクを削除するメソッド
  void deleteTask(int id) {
    _incompleteTasks.removeWhere((task) => task.id == id);
    _completedTasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  // タスクの並び替えを行うメソッド
  void reorderIncompleteTasks(int oldIndex, int newIndex) {
    Task task = _incompleteTasks.removeAt(oldIndex);
    _incompleteTasks.insert(newIndex, task);
    notifyListeners();
  }

  // ダークモードの状態を切り替えるメソッド
  void toggleDarkMode(bool value) async {
    _darkMode = value;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', value);
    notifyListeners();
  }

  // ダークモードの状態を読み込むメソッド
  Future<void> loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    _darkMode = prefs.getBool('darkMode') ?? false;
    notifyListeners();
  }
}
