import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

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

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final activeTaskCount = taskProvider.incompleteTasks.length;
    final completedTaskCount = taskProvider.completedTasks.length;

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
