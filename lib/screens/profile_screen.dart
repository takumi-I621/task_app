import 'package:flutter/material.dart';

// プロフィール画面
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'), // タイトル
      ),
      body: const Center(
        child: const Text('User Profile'), // ユーザープロフィールのテキスト
      ),
    );
  }
}
