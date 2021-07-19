import 'package:breakout_editor/data/block.dart';
import 'package:flutter/material.dart';

class BlockWidget extends StatelessWidget {
  final Block block;

  const BlockWidget({Key? key, required this.block}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: block.leftPos.toDouble(),
      top: block.topPos.toDouble(),
      child: Container(
          color: block.color.withAlpha(block.ghost ? 127 : 255),
          width: block.width.toDouble(),
          height: block.height.toDouble()),
    );
  }
}
