// lib/widgets/task_tile.dart

import 'package:flutter/material.dart';
import '../models/task.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final int index;

  const TaskTile({required this.task, required this.index, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.name),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Delete Task'),
              content: Text('Are you sure you want to delete this task?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Delete'),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        final taskProvider = Provider.of<TaskProvider>(context, listen: false);
        taskProvider.deleteTask(index); // タスクを削除
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 16.0),
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      // 追加：フリックの距離を短くする
      movementDuration: Duration(milliseconds: 200),
      direction: DismissDirection.endToStart,
      child: ListTile(
        title: Text(task.name),
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (value) {
            final taskProvider = Provider.of<TaskProvider>(context, listen: false);
            taskProvider.toggleTask(index); // タスクの完了状態を切り替える
          },
        ),
        trailing: ReorderableDragStartListener(
          index: index,
          child: Icon(Icons.drag_handle),
        ),
      ),
    );
  }
}
