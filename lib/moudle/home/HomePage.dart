// ======================
// 2. 首页：里面有 顶部3个Tab（关注 / 发现 / 绍兴）
// ======================
import 'package:flutter/material.dart';
import 'package:xiaohongshu_clone/moudle/home/XiaoHongShuGridPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {

  //懒加载，在initState 中 对他进行初始化
  late TabController _tabController;

  //数据源
  final List<String> _tabList = [
    "关注",
    "发现",
    "绍兴",
  ];


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabList.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    //左侧
    Widget leadingWidget = IconButton(
      icon: const Icon(Icons.camera_alt_outlined, color: Colors.black),
      onPressed: () {
        // 这里写打开相机/扫码的逻辑
      },
    );

    //中间
    TabBar tabBar = TabBar(
        controller: _tabController,
        isScrollable: false,
        // 固定平分宽度
        labelColor: Colors.black,
        dividerColor: Colors.transparent, //不展示分割线
        //选中的字体颜色
        unselectedLabelColor: Colors.grey,
        //非选中的字体颜色
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 16),
        labelPadding: EdgeInsets.zero,
        // 消除默认内边距
        indicatorSize: TabBarIndicatorSize.label,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(width: 2, color: Colors.red),
          insets: EdgeInsets.symmetric(horizontal: 30),
        ),
        tabs: _tabList.map((title) {
          return Tab(text: title);
        }).toList()
    ); //TabBar
    Widget centerWidget = SizedBox(
        width: MediaQuery
            .of(context)
            .size
            .width * 0.4, // 限制宽度，避免溢出
        child: tabBar
    );

    //右侧
    List<Widget> actionsWidgets =  [
      IconButton(
        icon: const Icon(Icons.search, color: Colors.black),
        onPressed: () {
          // 这里写打开搜索页的逻辑
        },
      ),
      const SizedBox(width: 8), // 右侧按钮间距
    ];


    //【1】顶部AppBar
    AppBar appBar = AppBar(

        elevation: 0, // 👈 去掉AppBar的默认阴影
        shadowColor: Colors.transparent, // 👈 彻底隐藏阴影
        backgroundColor: Colors.white,//背景色

        //1、左侧
        leading: leadingWidget,

        //2、中间
        title: centerWidget,
        centerTitle: true,   // 关键：让 title（TabBar）居中

        //3、右侧控件：搜索按钮
        actions:actionsWidgets

    );

    //【2】下方TabBarView
    TabBarView tabBarView = TabBarView( // 内容联动
        controller: _tabController,
        physics: const AlwaysScrollableScrollPhysics(),
        // 🔥关键：开启页面左右滑动切换，禁止手势拦截
        children: _tabList
            .asMap()
            .entries
            .map((
            entry) { //asMap() = 把 List 转成 Map<int, 类型> ,key = 索引 index ,value = 元素内容
          int index = entry.key; // 索引 0,1,2,3...
          String title = entry.value; // 标题
          return _TabContentPage(title: title, index: index,);
        }).toList()
    );


    //一整个就是 ：Scaffold =  appBar +  tabBarView
    return Scaffold(
      appBar: appBar,
      body: tabBarView,
    );
  }
}


// 每个 tab 对应的内容页面（复用）
class _TabContentPage extends StatelessWidget {
  final String title;
  final int index;

  const _TabContentPage({required this.title, required this.index});

  @override
  Widget build(BuildContext context) {
    //
    return DiscoverPage();

  }
}


/*
一、卡顿根本原因
Tab 切换页面销毁重建，重复初始化数据、重建视图
大量网络图片重复加载、无缓存、异常阻塞 UI
页面嵌套层级多，布局重绘频繁
TabBarView 左右滑动与列表滚动冲突引发抖动
首次进入一次性渲染大量 Item，主线程阻塞

二、必开核心优化（解决 90% 卡顿）
1. 页面保活（最关键）
页面继承混合类，切换不销毁不重建  （混入 AutomaticKeepAliveClientMixin ，重写wantKeepAlive）
作用：页面只初始化一次，切 Tab 直接读取缓存页面

2. 图片加载优化
弃用Image.network，统一使用CachedNetworkImage
自带内存 + 磁盘缓存，二次加载秒出
添加placeholder占位图、errorWidget异常兜底
限制解码尺寸 memCacheWidth 降低 GPU 渲染压力
全局管控图片缓存大小，防止内存溢出

3. 减少页面重绘
列表 Item 外层包裹 RepaintBoundary 隔离重绘区域
精简 Widget 嵌套，删除多余 Container、无效阴影
固定组件宽高，减少动态布局计算


4. 列表渲染优化
给瀑布流 / 列表添加 cacheExtent 预渲染可视区域外内容
假数据：数据在initState一次性初始化，不在 build 内创建
真数据：分页懒加载，不一次性请求全部数据

* */