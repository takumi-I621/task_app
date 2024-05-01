import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

// 設定画面
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'), // タイトル
      ),
      body: Center(
        child: SwitchListTile(
          title: const Text('Dark Mode'), // スイッチのタイトル
          value: Provider.of<TaskProvider>(context).darkMode, // 現在のダークモードの状態を取得
          onChanged: (value) {
            Provider.of<TaskProvider>(context, listen: false) // タスクプロバイダーを取得
                .toggleDarkMode(value); // ダークモードの状態を切り替え
          },
        ),
      ),
    );
  }
}
