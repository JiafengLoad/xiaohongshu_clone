// ======================
// 你的小红书卡片页面（修复版：图片全部正常显示 + 样式还原小红书）
// ======================
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// ======================
// 小红书卡片：图片 + 视频 混合版（可播放）
// ======================

import '../detail/VideoPlayerWidget.dart';
import '../detail/XhsImageDetailPage.dart';

// 👇 扩展模型：支持 图片 / 视频
enum NoteType { image, video }

class NoteItem {
  final NoteType type;       // 类型：图片 / 视频
  final String? imageUrl;    // 图片地址
  final String? videoUrl;   // 视频地址
  final String title;
  final String authorName;
  final String avatarUrl;
  final int likeCount;
  final String? desc;


  NoteItem({
    required this.type,
    this.imageUrl,
    this.videoUrl,
    required this.title,
    required this.desc,
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

class _DiscoverPageState extends State<DiscoverPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final List<NoteItem> noteList;

  @override
  void initState() {
    super.initState();

    // 👇 混合数据：图片 + 视频
    noteList = [
      // 视频卡片（3条）
      NoteItem(
        type: NoteType.video,
        videoUrl: "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
        title: "这是一条小红书短视频",
        desc: "家人们，谁懂啊，这是一条小红书视频呢",
        authorName: "视频博主",
        avatarUrl: "https://picsum.photos/200/200?random=100",
        likeCount: 1234,
      ),
      NoteItem(
        type: NoteType.video,
        videoUrl: "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
        title: "蝴蝶飞舞的瞬间",
        desc: "家人们，谁懂啊，这是一条蝴蝶视频呢",
        authorName: "大自然摄影",
        avatarUrl: "https://picsum.photos/200/200?random=101",
        likeCount: 5678,
      ),

      // 图片卡片（全部）
      for (int i = 0; i < 12; i++)
        NoteItem(
          type: NoteType.image,
          imageUrl: "https://picsum.photos/400/600?random=$i",
          title: "人类到底想要什么样的情感？",
          desc: "家人们，谁懂啊，这是阿卡迪萨的文案呢",
          authorName: "阿卡迪萨",
          avatarUrl: "https://picsum.photos/200/200?random=${i + 10}",
          likeCount: 100 + i * 3,
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: MasonryGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          itemCount: noteList.length,
          // itemBuilder: (context, index) {
          //   return RepaintBoundary(
          //     child: _buildCard(noteList[index]),
          //   );
          // },

            itemBuilder: (context, index) {
              final item = noteList[index];
              return GestureDetector(
                // 🔥 点击卡片 → 弹出小红书详情页（核心）
                onTap: () {
                  _openXhsDetailPage(context, item);
                },
                child: _buildNoteCard(item),
              );
            }),
      ),
    );
  }

  // 👇 自动区分：图片卡片 / 视频卡片
  Widget _buildNoteCard(NoteItem note) {
    switch (note.type) {
      case NoteType.image:
        return _imageCard(note);
      case NoteType.video:
        return _videoCard(note);
    }
  }

  // 👇 图片卡片
  Widget _imageCard(NoteItem note) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: note.imageUrl!,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(height: 180, color: Colors.grey[200]),
            errorWidget: (_, __, ___) => Container(height: 180, color: Colors.grey),
          ),
          _buildBottomInfo(note),
        ],
      ),
    );
  }

  // 👇 视频卡片（可播放、带暂停/开始）
  Widget _videoCard(NoteItem note) {
    return VideoPlayerWidget(
      videoUrl: note.videoUrl!,
      child: _buildBottomInfo(note),
    );
  }

  // 👇 底部通用：标题、头像、点赞
  Widget _buildBottomInfo(NoteItem note) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            note.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: ClipOval(
                  child: CachedNetworkImage(imageUrl: note.avatarUrl),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  note.authorName,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ),
              const Icon(Icons.favorite_border, size: 12, color: Colors.grey),
              const SizedBox(width: 2),
              Text('${note.likeCount}', style: const TextStyle(fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }



  // 🔥🔥🔥 核心：打开小红书【弹出式详情页】（覆盖效果）
  void _openXhsDetailPage(BuildContext context, NoteItem item) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false, // 关键：背景透明 → 覆盖效果
        pageBuilder: (_, __, ___) => XhsImageDetailPage(item: item),
        transitionsBuilder: (_, animation, __, child) {
          // 🔥 小红书动画：中心放大弹出
          return ScaleTransition(
            alignment: Alignment.center,
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            ),
            child: FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 250),
      ),
    );
  }
}


