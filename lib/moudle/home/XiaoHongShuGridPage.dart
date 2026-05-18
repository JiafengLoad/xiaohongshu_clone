// ======================
// 你的小红书卡片页面
// ======================
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:xiaohongshu_clone/moudle/home/XiaoHongShuCard.dart';
import 'package:flutter/material.dart';


// 假数据模型
class NoteItem {
  final String imageUrl;
  final String title;
  final String authorName;
  final String avatarUrl;
  final int likeCount;

  NoteItem({
    required this.imageUrl,
    required this.title,
    required this.authorName,
    required this.avatarUrl,
    required this.likeCount,
  });
}


class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

// 🔥1. 让页面 “保持存活”，Tab 切换不重建  with AutomaticKeepAliveClientMixin
class _DiscoverPageState extends State<DiscoverPage> with AutomaticKeepAliveClientMixin {
  // 生成假数据
  late final List<NoteItem> notes;

  @override
  bool get wantKeepAlive => true; // Tab 切换不销毁页面

  @override
  void initState() {
    super.initState();
    // 初始化数据只执行一次
    notes = List.generate(15, (index) {
      return NoteItem(
        // 换一个国内可访问的图片源，避免网络异常
        imageUrl: "https://picsum.photos/300/${(300 + index * 100) % 500}?random=$index",
        title: [
          "人类到底想要什么样的情感？人类到底想要什么样的情感？人类到底想要什么样的情感？",
          "写材料，有窍门",
          "工作日的晚上也“排满”了",
          "唐嫣说英语太好听了，唐嫣说英语太好听了，唐嫣说英语太好听了，唐嫣说英语太好听了！",
          "时间就像海绵里的水，挤一挤总会有的",
          "生活中的小确幸，藏在细节里",
          "打工人的周末，就是用来回血的，打工人的周末，就是用来回血的，打工人的周末，就是用来回血的",
          "这份书单，解决你的书荒！",
          "百元租房改造，ins风拉满",
          "减脂餐也能吃得超满足！",
          "新手化妆教程，手残党也能会，新手化妆教程，手残党也能会，新手化妆教程，手残党也能会",
          "居家办公，效率翻倍的秘诀",
          "旅行中遇到的绝美风景",
          "养猫之后，生活被治愈了",
          "百元好物分享，平价不踩雷"
        ][index % 15],
        authorName: [
          "阿卡迪萨", "老笔杆", "爱折腾的馒头", "笑学英语", "生活家小王",
          "读书破万卷", "打工人日常", "美妆博主阿美", "租房改造达人", "美食家阿强"
        ][index % 10],
        avatarUrl: "https://picsum.photos/100/100?avatar=$index",
        likeCount: [17, 6, 3, 98, 120, 45, 89, 23, 150, 76][index % 10],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须加这行
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: MasonryGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          itemCount: notes.length,
          cacheExtent: 500, //  🔥可视区域外预渲染5个，滑动丝滑不卡顿
          physics: const AlwaysScrollableScrollPhysics(), // 🔥关键优化：给瀑布流加上固定 physics，避免和 Tab 滑动冲突
          itemBuilder: (context, index) {  // 🔥关键优化：用 RepaintBoundary 减少重绘
            // 强隔离重绘区域
            return RepaintBoundary(
                child: SizedBox(
                  width: double.infinity, // 约束最小尺寸，减少动态布局计算
                  child: _buildNoteCard(notes[index]),
                ),
            );
          },
        ),
      ),
    );
  }

  // 小红书笔记卡片UI（优化版）
// 优化后极简卡片，去掉冗余样式
  Widget _buildNoteCard(NoteItem note) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: note.imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            placeholder: (_,__)=>const SizedBox(height:150,child:ColoredBox(color:Colors.black12)),
            errorWidget: (_,__,___)=>const SizedBox(height:150,child:Icon(Icons.image_not_supported)),
            // 限制图片解码尺寸，大幅降低GPU渲染压力
            memCacheWidth: 300,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(note.title,maxLines:2,overflow:TextOverflow.ellipsis),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
            child: Row(
              children: [
                // 极简头像，去掉多余嵌套
                SizedBox(
                  width:20,height:20,
                  child: ClipOval(child: CachedNetworkImage(imageUrl: note.avatarUrl,fit:BoxFit.cover)),
                ),
                const SizedBox(width:6),
                Expanded(child: Text(note.authorName,style:TextStyle(fontSize:12,color:Colors.grey))),
                Icon(Icons.favorite_border,size:14,color:Colors.grey),
                Text('${note.likeCount}',style:TextStyle(fontSize:12,color:Colors.grey))
              ],
            ),
          )
        ],
      ),
    );
  }

}