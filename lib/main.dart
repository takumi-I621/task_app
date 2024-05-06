import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/task_provider.dart';
import './screens/todo_screen.dart';
import './screens/settings_screen.dart';
import './screens/profile_screen.dart';
import './screens/history_screen.dart'; // 追加

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider( // ルートプロバイダー
      create: (context) => TaskProvider()..loadDarkMode(), // TaskProviderのインスタンスを作成し、ダークモードの設定を読み込む
      child: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return MaterialApp(
            title: 'ToDo App', // アプリのタイトル
            theme: taskProvider.darkMode ? ThemeData.dark() : ThemeData.light(), // ダークモードのテーマを適用
            routes: {
              '/': (context) => ToDoScreen(), // メイン画面
              '/settings': (context) => SettingsScreen(), // 設定画面
              '/profile': (context) => ProfileScreen(), // プロフィール画面
              '/history': (context) => HistoryScreen(), // 追加
            },
          );
        },
      ),
    );
  }
}
