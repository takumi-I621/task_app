// lib/providers/task_provider.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = []; // タスクリスト
  bool _darkMode = false; // ダークモードの状態

  List<Task> get tasks => _tasks; // タスクリストを取得
  bool get darkMode => _darkMode; // ダークモードの状態を取得

  // タスクを追加するメソッド
  void addTask(String name) {
    _tasks.add(Task(name: name, isCompleted: false, priority: _tasks.length)); // タスクを追加
    notifyListeners(); // リスナーに変更を通知
  }

  // タスクの完了状態を切り替えるメソッド
  void toggleTask(int index) {
    _tasks[index].isCompleted = !_tasks[index].isCompleted; // タスクの完了状態を切り替え
    notifyListeners(); // リスナーに変更を通知
  }

  // タスクを削除するメソッド
  void deleteTask(int index) {
    _tasks.removeAt(index); // タスクを削除
    notifyListeners(); // リスナーに変更を通知
  }

  // ダークモードの状態を切り替えるメソッド
  void toggleDarkMode(bool value) async {
    _darkMode = value; // ダークモードの状態を切り替え
    final prefs = await SharedPreferences.getInstance(); // SharedPreferencesを取得
    prefs.setBool('darkMode', value); // ダークモードの状態を保存
    notifyListeners(); // リスナーに変更を通知
  }

  // ダークモードの状態を読み込むメソッド
  Future<void> loadDarkMode() async {
    final prefs = await SharedPreferences.getInstance(); // SharedPreferencesを取得
    _darkMode = prefs.getBool('darkMode') ?? false; // ダークモードの状態を読み込む
    notifyListeners(); // リスナーに変更を通知
  }

  // タスクの並び替えを行うメソッド
  void reorderTasks(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final Task task = _tasks.removeAt(oldIndex);
    _tasks.insert(newIndex, task);
    notifyListeners();
  }
}