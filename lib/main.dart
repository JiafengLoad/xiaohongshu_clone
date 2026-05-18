import 'package:flutter/material.dart';
import 'package:xiaohongshu_clone/market/home/page/MarketPage.dart';
import 'package:xiaohongshu_clone/moudle/add/AddPage.dart';
import 'package:xiaohongshu_clone/moudle/home/HomePage.dart';
import 'package:xiaohongshu_clone/moudle/message/MessagePage.dart';
import 'package:xiaohongshu_clone/moudle/mine/mine.dart';

// 主函数
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const RootPage(), // 根页面（底部导航）
    );
  }
}

// ======================
// 1. 根页面：底部5个导航
// ======================
class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> { //混入SingleTickerProviderStateMixin

  //选中索引
  int _selectedIndex = 0;

  // 5个页面
  final List<Widget> _pages = [
    const HomePage(),        // 首页（里面有顶部3个Tab）
    const MarketPage(),      // 市集
    const AddPage(),         // +
    const MessagePage(),     // 消息
    const MinePage(),        // 我的
  ];

  //5个底部icon
  List<BottomNavigationBarItem> _items = const [
   BottomNavigationBarItem(icon: Icon(Icons.home), label: "首页"),
   BottomNavigationBarItem(icon: Icon(Icons.store), label: "市集"),
   BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: ""),
   BottomNavigationBarItem(icon: Icon(Icons.message), label: "消息"),
   BottomNavigationBarItem(icon: Icon(Icons.person), label: "我"),
  ];




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // 显示当前页面
      // body: IndexedStack(
      //   index: _selectedIndex, // 根据选中的索引显示对应的页面
      //   children: _pages,
      // ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: _items,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });

        },
      ),

    );
  }
}



