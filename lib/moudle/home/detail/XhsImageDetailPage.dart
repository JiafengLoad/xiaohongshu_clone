
// ======================
// 🔥 小红书图文详情页（完整高仿）
// ======================
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../home/XiaoHongShuGridPage.dart';

class XhsImageDetailPage extends StatelessWidget {
  final NoteItem item;

  const XhsImageDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 关键：背景透明 → 看到首页
      backgroundColor: Colors.black.withOpacity(0.85),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 顶部返回栏
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 返回按钮
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
                      onPressed: () => Navigator.pop(context),
                    ),
                    // 更多按钮
                    IconButton(
                      icon: const Icon(Icons.more_horiz, color: Colors.white, size: 24),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // 详情大图
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: item.imageUrl??"",
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // 标题
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  item.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ),

              // 作者信息
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: item.avatarUrl,
                        width: 36,
                        height: 36,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.authorName,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          "刚刚发布",
                          style: TextStyle(color: Colors.grey, fontSize: 11),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // 关注按钮
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "+ 关注",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),

              // 详情内容
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  item.desc??"",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 底部工具栏（点赞、评论、收藏、转发）
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildBottomBarIcon(Icons.favorite_border, "${item.likeCount}"),
                    _buildBottomBarIcon(Icons.chat_bubble_outline, "120"),
                    _buildBottomBarIcon(Icons.star_border, "35"),
                    _buildBottomBarIcon(Icons.share, "分享"),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // 底部工具栏按钮
  Widget _buildBottomBarIcon(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(height: 4),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 11)),
      ],
    );
  }
}