// lib/screen/todo_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_tile.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ToDoScreenState createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  late TextEditingController _taskController;
  String? _selectedCategory = "仕事";
  final List<String> _categories = ['仕事', '家事', '個人', 'その他'];

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController();
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ToDo App'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '実行中タスク'),
              Tab(text: '完了タスク'),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: const Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              ListTile(
                title: const Text('Settings'),
                onTap: () {
                  // Setting画面に遷移
                  Navigator.pushNamed(context, '/settings');
                },
              ),
              ListTile(
                title: const Text('Profile'),
                onTap: () {
                  // Profile画面に遷移
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              ListTile(
                title: const Text('History'),
                onTap: () {
                  // History画面に遷移
                  Navigator.pushNamed(context, '/history');
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTaskList(context, false), // 実行中タスクのリストを表示
            _buildTaskList(context, true), // 完了タスクのリストを表示
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddTaskDialog(context); // タスクを追加するダイアログを表示
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  // タスクリストを表示するウィジェット
  Widget _buildTaskList(BuildContext context, bool completed) {
    final taskProvider = Provider.of<TaskProvider>(context);
    var tasks = taskProvider.tasks
        .where((task) => task.isCompleted == completed)
        .toList();

    return ReorderableListView(
      onReorder: (oldIndex, newIndex) {
        if(oldIndex == tasks.length) {
          if (newIndex >= 0 && newIndex < tasks.length) { // インデックスが範囲内にあるか確認
            taskProvider.reorderTasks(oldIndex, newIndex); // タスクの並び替えを実行
          }
        }else{
          if (newIndex >= 0 && newIndex <= tasks.length) { // インデックスが範囲内にあるか確認
            taskProvider.reorderTasks(oldIndex, newIndex); // タスクの並び替えを実行
          }
        }
      },
      children: tasks
          .map((task) => TaskTile(
        task: task,
        index: taskProvider.tasks.indexOf(task),
        key: ValueKey(task),
        taskProvider: taskProvider, // TaskTileにTaskProviderを渡す
      ))
          .toList(),
    );
  }

// タスクを追加するダイアログを表示
  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // 追加: ダイアログ内でもsetStateが使えるようにする
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _taskController,
                    decoration:
                        const InputDecoration(hintText: 'Enter task name'),
                    autofocus: true,
                  ),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    value: _selectedCategory,
                    onChanged: (String? newValue) {
                      setState(() {
                        // 修正: 内部でsetStateを使用して更新を反映
                        _selectedCategory = newValue;
                      });
                    },
                    items: _categories
                        .map<DropdownMenuItem<String>>((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _taskController.clear();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_taskController.text.isNotEmpty) {
                      final taskProvider =
                          Provider.of<TaskProvider>(context, listen: false);
                      taskProvider.addTask(_taskController.text,
                          category: _selectedCategory ?? 'その他'); // カテゴリも追加
                      Navigator.of(context).pop();
                      _taskController.clear();
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
