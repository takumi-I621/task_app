import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../providers/task_provider.dart';

// 設定画面
class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String _selectedTimeZone;
  late List<DropdownMenuItem<String>> _timeZoneItems;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    _selectedTimeZone = taskProvider.timeZone;

    // タイムゾーンのリストを初期化
    _timeZoneItems = tz.timeZoneDatabase.locations.keys.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'), // タイトル
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            SwitchListTile(
              title: const Text('Dark Mode'), // スイッチのタイトル
              value: taskProvider.darkMode, // 現在のダークモードの状態を取得
              onChanged: (value) {
                taskProvider.toggleDarkMode(value); // ダークモードの状態を切り替え
              },
            ),
            DropdownButton<String>(
              value: _timeZoneItems.any((item) => item.value == _selectedTimeZone) ? _selectedTimeZone : null,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedTimeZone = newValue;
                  });
                  taskProvider.setTimeZone(newValue);
                }
              },
              items: _timeZoneItems, // タイムゾーンアイテムを設定
            ),
          ],
        ),
      ),
    );
  }
}
