// lib/widgets/task_tile.dart

import 'package:flutter/material.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final int index;
  final TaskProvider taskProvider; // TaskProviderを受け取るフィールドを追加

  const TaskTile({required this.task, required this.index, Key? key, required this.taskProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id.toString()),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete Task'),
              content: const Text('Are you sure you want to delete this task?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        taskProvider.deleteTask(task.id); // 修正：taskProviderを使用してタスクを削除
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 16.0),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      // 追加：フリックの距離を短くする
      movementDuration: Duration(milliseconds: 200),
      direction: DismissDirection.endToStart,
      child: ListTile(
        title: Text(task.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.category), // カテゴリ情報をサブタイトルとして表示
            Text('作成日: ${task.createdDate.year}'
                '/${task.createdDate.month}'
                '/${task.createdDate.day}'
                ' ${task.createdDate.hour}'
                ':${task.createdDate.minute}'),
          ],
        ),
        //task.isCompketedがnullならアイコンをnullにする。
        trailing: task.isCompleted ? null :
          Row( // 右側に並び替え用アイコンを配置するためのRowウィジェットを追加
            mainAxisSize: MainAxisSize.min,
            children: [
              ReorderableDragStartListener(
                index: index,
                child: Icon(Icons.drag_handle),
            ),
          ],
        ),
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (bool? value) {
            if (value != null) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('確認'),
                    content: Text(task.isCompleted ? 'タスクを未完了にしますか？' : 'タスクを完了しますか？'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // ダイアログを閉じる
                        },
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // ダイアログを閉じる
                          taskProvider.toggleTask(task.id); // タスクのIDを使って完了状態を切り替える
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
