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
  String? _selectedCategory; // 選択されたカテゴリを保持する変数
  final List<String> _categories = ['仕事', '家事', '個人', 'その他']; // カテゴリのリスト

  // カテゴリボタンの状態を管理する変数
  bool isWorkSelected = false;
  bool isHouseworkSelected = false;
  bool isPersonalSelected = false;
  bool isOtherSelected = false;

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
    final tasks = taskProvider.tasks.where((task) => task.isCompleted == completed).toList();

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

  // タスクを追加するダイアログを表示
  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _taskController,
                decoration: InputDecoration(hintText: 'Enter task name'),
                autofocus: true,
              ),
              SizedBox(height: 8),
              Row(
                children: _categories.take(4).map((category) {
                  return Expanded(
                    child: SizedBox( // ボタンのサイズを均一にするためにSizedBoxを使用
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _onCategoryButtonTap(category);
                        },
                        style: ElevatedButton.styleFrom(primary: _getButtonColor(category)),
                        child: FittedBox( // 名称に応じてフォントサイズを可変にする
                          fit: BoxFit.contain,
                          child: Text(
                            category,
                            textAlign: TextAlign.center, // 横書きで収まるようにする
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _taskController.clear();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_taskController.text.isNotEmpty) {
                  final taskProvider = Provider.of<TaskProvider>(context, listen: false);
                  taskProvider.addTask(_taskController.text, category: _selectedCategory ?? 'その他'); // カテゴリも追加
                  Navigator.of(context).pop();
                  _taskController.clear();
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // カテゴリボタンのタップ時の処理
  void _onCategoryButtonTap(String category) {
    setState(() {
      // 選択されたカテゴリに応じて状態を切り替える
      switch (category) {
        case '仕事':
          isWorkSelected = !isWorkSelected;
          break;
        case '家事':
          isHouseworkSelected = !isHouseworkSelected;
          break;
        case '個人':
          isPersonalSelected = !isPersonalSelected;
          break;
        case 'その他':
          isOtherSelected = !isOtherSelected;
          break;
      }
    });
  }

  // カテゴリボタンのスタイル
  Color _getButtonColor(String category) {
    switch (category) {
      case '仕事':
        return isWorkSelected ? Colors.blue : Colors.transparent;
      case '家事':
        return isHouseworkSelected ? Colors.blue : Colors.transparent;
      case '個人':
        return isPersonalSelected ? Colors.blue : Colors.transparent;
      case 'その他':
        return isOtherSelected ? Colors.blue : Colors.transparent;
      default:
        return Colors.transparent;
    }
  }
}
