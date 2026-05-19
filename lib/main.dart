import 'package:flutter/material.dart';
import 'module/root/RootPage.dart';




// 主函数
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RootPage(), // 根页面（底部导航）
    );
  }
}




