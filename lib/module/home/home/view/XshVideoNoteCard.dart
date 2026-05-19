


import 'package:flutter/cupertino.dart';

import '../model/XhsNoteItem.dart';

class XhsVideoNoteCard extends StatefulWidget {

  final XhsNoteItem noteItem;  //item
  final VoidCallback? onTap; //回调

  const XhsVideoNoteCard({
    super.key, required this.noteItem, this.onTap
  });

  @override
  State<XhsVideoNoteCard> createState() => _XhsVideoNoteCardState();
}

class _XhsVideoNoteCardState extends State<XhsVideoNoteCard> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
