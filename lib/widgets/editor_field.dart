import 'package:breakout_editor/bloc/editor_bloc.dart';
import 'package:breakout_editor/data/level.dart';
import 'package:breakout_editor/widgets/block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditorField extends StatelessWidget {
  final Level level;
  final Function(int blockIndex) blockTapCallback;
  final Function(TapUpDetails details) canvasTapUpCallback;
  final Function(DragUpdateDetails details) canvasDragUpdateCallback;
  final Function(DragStartDetails details) canvasDragStartCallback;
  final Function(DragEndDetails details) canvasDragEndCallback;

  const EditorField(
      {Key? key,
      required this.level,
      required this.blockTapCallback,
      required this.canvasDragStartCallback,
      required this.canvasDragUpdateCallback,
      required this.canvasDragEndCallback,
      required this.canvasTapUpCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      _backgroundCard(),
      for (int i = 0; i < level.levelData.length; i++)
        BlockWidget(
            block: level.levelData[i], onClick: () => blockTapCallback(i))
    ]);
  }

  Widget _backgroundCard() {
    return GestureDetector(
      onTapUp: canvasTapUpCallback,
      onPanUpdate: canvasDragUpdateCallback,
      onPanStart: canvasDragStartCallback,
      onPanEnd: canvasDragEndCallback,
      child: Container(
        height: 128,
        width: 128,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(offset: Offset(1, 1), blurRadius: 5.0, spreadRadius: 0.5)
        ], color: Colors.black),
      ),
    );
  }
}
