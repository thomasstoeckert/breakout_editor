import 'package:breakout_editor/bloc/toolbar_bloc.dart';
import 'package:breakout_editor/data/level.dart';
import 'package:breakout_editor/widgets/block.dart';
import 'package:breakout_editor/widgets/tool_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Editor extends StatefulWidget {
  const Editor({Key? key}) : super(key: key);

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  static const _levelString =
      '''{{1, 1, 20, 8}, {22, 1, 42, 8}, {44, 1, 64, 8}, {66, 1, 86, 8}, {88, 1, 108, 8}, {110, 1, 127, 8}, {1, 10, 20, 18}, {22, 10, 42, 18}, {44, 10, 64, 18}, {66, 10, 86, 18}, {88, 10, 108, 18}, {110, 10, 127, 18}, {1, 20, 20, 28}, {22, 20, 42, 28}, {44, 20, 64, 28}, {66, 20, 86, 28}, {88, 20, 108, 28}, {110, 20, 127, 28}, {1, 30, 20, 38}, {22, 30, 42, 38}, {44, 30, 64, 38}, {66, 30, 86, 38}, {88, 30, 108, 38}, {110, 30, 127, 38}, {1, 40, 20, 48}, {22, 40, 42, 48}, {44, 40, 64, 48}, {66, 40, 86, 48}, {88, 40, 108, 48}, {110, 40, 127, 48}}''';

  Level? levelData;

  @override
  void initState() {
    super.initState();
    levelData = Level.fromString(_levelString);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> builtBlocks = <Widget>[];

    levelData?.levelData.forEach((element) {
      builtBlocks.add(BlockWidget(block: element));
    });

    return Scaffold(
      body: BlocProvider<ToolbarBloc>(
        create: (context) => ToolbarBloc(),
        child: SafeArea(
            child: Stack(children: [
          Center(
              child: InteractiveViewer(
                  minScale: 2.0,
                  maxScale: 4.0,
                  panEnabled: false,
                  child: Center(
                      child: Stack(
                    children: [
                      Container(
                        width: 128,
                        height: 128,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: Colors.red)),
                      ),
                      ...builtBlocks
                    ],
                  )))),
          ToolBar()
        ])),
      ),
    );
  }
}
