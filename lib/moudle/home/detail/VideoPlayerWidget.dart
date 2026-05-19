

// ======================
// 视频播放器组件（可直接播放网络视频）
// ======================
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'XhsImageDetailPage.dart';
import '../home/XiaoHongShuGridPage.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final Widget child;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    required this.child,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _controller.value.isPlaying ? _controller.pause() : _controller.play();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: _controller.value.isInitialized
                      ? VideoPlayer(_controller)
                      : Container(height: 180, color: Colors.black),
                ),
                // 播放按钮
                if (!_controller.value.isPlaying)
                  const Icon(
                    Icons.play_arrow,
                    size: 50,
                    color: Colors.white,
                  ),
              ],
            ),
            widget.child,
          ],
        ),
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