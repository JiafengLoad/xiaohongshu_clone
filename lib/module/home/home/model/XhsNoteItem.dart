


// 👇 扩展模型：支持 图片 / 视频
enum NoteType { image, video }

class XhsNoteItem {
  final NoteType type; // 类型：图片 / 视频
  final String? imageUrl; // 图片地址
  final String? videoUrl; // 视频地址
  final String title;
  final String authorName;
  final String avatarUrl;
  final int likeCount;
  final String? desc;

  XhsNoteItem({
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