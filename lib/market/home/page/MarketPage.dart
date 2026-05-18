import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:xiaohongshu_clone/market/home/model/TabCategoryModel.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;


  // 混合数据源：第2个是图片，其他纯文字
  final List<TabCategoryModel> _categories = [
    TabCategoryModel(title: "推荐"),
    TabCategoryModel(
      // title: "穿搭",
      iconUrl: "https://picsum.photos/30/30?random=2", // 只有这个有图片
    ),
    TabCategoryModel(title: "运动"),
    TabCategoryModel(title: "食饮"),
    TabCategoryModel(title: "生鲜"),
    TabCategoryModel(title: "潮玩"),
    TabCategoryModel(title: "家居"),
    TabCategoryModel(title: "文玩"),
    TabCategoryModel(title: "数码"),
    TabCategoryModel(title: "美妆"),
  ];

  @override
  void initState() {
    super.initState();
    // 初始化 TabController，长度和分类数量一致
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    //搜索框
    TextField textField = TextField(
      decoration: InputDecoration(
        hintText: "黑小麦",
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[100],
      ),
    );

    //tabBar
    TabBar tabBar = TabBar(
      controller: _tabController,
      // 关键：isScrollable = true 时，标签超出屏幕会自动支持左右滑动
      isScrollable: true,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey,
      labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontSize: 16),
      // 去掉默认内边距，避免标签被挤压
      labelPadding: const EdgeInsets.symmetric(horizontal: 16),
      indicatorSize: TabBarIndicatorSize.label,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(width: 2, color: Colors.red),
        insets: EdgeInsets.symmetric(horizontal: 10),
      ),


      // 动态生成分类标签
      // tabs: categories.map((cat) => Tab(text: cat)).toList(),
      tabs: _categories.map((model) {
        final hasImage = model.iconUrl != null && model.iconUrl!.isNotEmpty;

        return Tab(
          // 关键：用 SizedBox 强制给 Tab 足够高度，让图片显示
          child: SizedBox(
            height: 42, // 这里给固定高度，所有版本都支持
            child: hasImage
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: model.iconUrl!,
                  width: 24,
                  height: 24,
                ),
                // const SizedBox(height: 2),
                // Text(
                //   model.title!,
                //   style: const TextStyle(fontSize: 11),
                // ),
              ],
            )
                : Center(
              child: Text(
                model.title!,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        );
      }).toList(),

    );

    //tabBarView
    TabBarView tabBarView = TabBarView(
      controller: _tabController,
      // 可选：禁用页面左右滑动，只保留点击标签切换
      // physics: const NeverScrollableScrollPhysics(),
      children: _categories.map((cat) {
        // 每个分类对应的页面，这里用列表模拟商品流
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: 20,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  "$cat 分类商品 $index",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            );
          },
        );
      }).toList(),
    );

    return Scaffold(
      body: Column(
        children: [
          // 1. 顶部搜索栏（可选）
          Padding(padding: const EdgeInsets.all(16), child: textField),
          // 2. 核心：可滑动的分类 TabBar
          tabBar,
          // 3. 下方联动的页面
          Expanded(child: tabBarView),
        ],
      ),
    );
  }
}
