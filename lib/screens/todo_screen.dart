// lib/screen/todo_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_tile.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({Key? key}) : super(key: key);

  @override
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
                  Navigator.pushNamed(context, '/settings');
                },
              ),
              ListTile(
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              ListTile(
                title: const Text('History'),
                onTap: () {
                  Navigator.pushNamed(context, '/history');
                },
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildReorderableTaskList(context), // 実行中タスクのリストを表示
            _buildCompletedTaskList(context), // 完了タスクのリストを表示
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

  Widget _buildReorderableTaskList(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    var tasks = taskProvider.incompleteTasks;

    return Padding(
      padding: const EdgeInsets.only(bottom: 70.0), // フローティングアクションボタンに重ならないようにpaddingを設定
      child: ReorderableListView.builder(
        key: PageStorageKey('IncompleteTasks'),
        itemCount: tasks.length,
        onReorder: (oldIndex, newIndex) {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          taskProvider.reorderIncompleteTasks(oldIndex, newIndex);
        },
        itemBuilder: (context, index) {
          return TaskTile(
            task: tasks[index],
            index: index,
            key: ValueKey(tasks[index].id), // タスクIDを利用
            taskProvider: taskProvider,
          );
        },
      ),
    );
  }

  Widget _buildCompletedTaskList(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    var tasks = taskProvider.completedTasks;

    return Padding(
      padding: const EdgeInsets.only(bottom: 70.0), // フローティングアクションボタンに重ならないようにpaddingを設定
      child: ListView.builder(
        key: PageStorageKey('CompletedTasks'),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return TaskTile(
            task: tasks[index],
            index: index,
            key: ValueKey(tasks[index].id), // タスクIDを利用
            taskProvider: taskProvider,
          );
        },
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
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
                          category: _selectedCategory ?? 'その他');
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
