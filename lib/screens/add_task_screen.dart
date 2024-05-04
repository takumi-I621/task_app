import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class AddTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String taskName = '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) {
                taskName = value;
              },
              decoration: InputDecoration(
                labelText: 'Enter task name',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (taskName.isNotEmpty) {
                  Provider.of<TaskProvider>(context, listen: false).addTask(taskName, category: '');
                  Navigator.of(context).pop(); // ボタンを押した後、画面を閉じる
                }
              },
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}

// タスクの件数を表示するウィジェット
class TaskCountWidget extends StatelessWidget {
  final String label;
  final int count;

  TaskCountWidget({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text('$label: $count Tasks'),
    );
  }
}

class TaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final activeTaskCount = taskProvider.tasks.where((task) => !task.isCompleted).length;
    final completedTaskCount = taskProvider.tasks.where((task) => task.isCompleted).length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        actions: [
          TaskCountWidget(label: 'Active Tasks', count: activeTaskCount),
          TaskCountWidget(label: 'Completed Tasks', count: completedTaskCount),
        ],
      ),
      body: Center(
        child: Text('Task List'),
      ),
    );
  }
}
