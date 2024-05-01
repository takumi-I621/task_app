// lib/screens/todo_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_tile.dart';
import 'add_task_screen.dart';

class ToDoScreen extends StatelessWidget {
  const ToDoScreen({Key? key});

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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTaskScreen()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  // タスクリストを表示するウィジェット
  Widget _buildTaskList(BuildContext context, bool completed) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks =
    taskProvider.tasks.where((task) => task.isCompleted == completed).toList();

    return ReorderableListView(
      onReorder: (oldIndex, newIndex) {
        taskProvider.reorderTasks(oldIndex, newIndex); // タスクの並び替えを実行
      },
      children: tasks
          .map((task) => TaskTile(
        task: task,
        index: taskProvider.tasks.indexOf(task),
        key: ValueKey(task),
      ))
          .toList(),
    );
  }
}