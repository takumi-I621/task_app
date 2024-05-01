import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_tile.dart';
import 'add_task_screen.dart';

class ToDoScreen extends StatelessWidget {
  const ToDoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // タブの数を指定
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ToDo App'),
          /*actions: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                // ハンバーガーメニューがタップされたときにDrawerを開く
                Scaffold.of(context).openDrawer();
              },
            ),
          ],*/
          bottom: const TabBar(
            tabs: [
              Tab(text: '実行中タスク'), // タブ1: 実行中タスク
              Tab(text: '完了タスク'),   // タブ2: 完了タスク
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
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTaskList(context, false), // 実行中タスクのリストを表示
            _buildTaskList(context, true),  // 完了タスクのリストを表示
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              // 新しいタスクを追加する画面に遷移
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
    // 実行中タスクか完了タスクかでフィルタリング
    final tasks = taskProvider.tasks.where((task) => task.isCompleted == completed).toList();

    // タスクを優先順位でソート
    tasks.sort((a, b) => a.priority.compareTo(b.priority));


    // ここから下はそのままのコード
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        // タスクを表示するウィジェットを返す
        return TaskTile(index: taskProvider.tasks.indexOf(tasks[index]));
      },
    );
  }


}
