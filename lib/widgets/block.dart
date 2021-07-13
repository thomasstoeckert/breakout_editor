import 'package:breakout_editor/data/block.dart';
import 'package:flutter/material.dart';

class BlockWidget extends StatelessWidget {
  final Block block;
  final VoidCallback onClick;

  const BlockWidget({Key? key, required this.block, required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: block.leftPos.toDouble(),
        top: block.topPos.toDouble(),
        child: InkWell(
          child: Container(
              color: Colors.blue,
              width: block.width.toDouble(),
              height: block.height.toDouble()),
          onTap: () => onClick(),
        ));
  }
}
