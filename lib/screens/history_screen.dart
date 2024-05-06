// lib/screens/history_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: Center(
        child: Consumer<TaskProvider>(
          builder: (context, taskProvider, _) {
            // TaskProviderから完了したタスクの数を取得して表示する
            final completedTaskCount = taskProvider.completedTaskCount();
            return Text('Completed Tasks: $completedTaskCount');
          },
        ),
      ),
    );
  }
}
