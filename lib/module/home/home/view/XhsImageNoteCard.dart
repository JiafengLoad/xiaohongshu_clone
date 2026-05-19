
// // 👇 图片卡片

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../model/XhsNoteItem.dart';


class ImageNoteCard  extends StatefulWidget {

  final XhsNoteItem noteItem;  //item
  final VoidCallback? onTap; //回调

  const ImageNoteCard({  //构造器传入item 和 点击回调
    super.key,
    required this.noteItem,
    this.onTap,
    });

  @override
  State<ImageNoteCard> createState() => _ImageNoteCardState();
}

class _ImageNoteCardState extends State<ImageNoteCard> {
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      //点击事件
      onTap: widget.onTap,
      //UI
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: widget.noteItem.imageUrl!,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                height: 180,
                color: Colors.grey[200],
              ),
              errorWidget: (_, __, ___) => Container(
                height: 180,
                color: Colors.grey,
              ),
            ),
            _buildBottomInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomInfo() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.noteItem.title,
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
                  child: CachedNetworkImage(
                    imageUrl: widget.noteItem.avatarUrl,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  widget.noteItem.authorName,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ),
              const Icon(
                Icons.favorite_border,
                size: 12,
                color: Colors.grey,
              ),
              const SizedBox(width: 2),
              Text(
                '${widget.noteItem.likeCount}',
                style: const TextStyle(fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


