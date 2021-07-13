import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:breakout_editor/bloc/editor_bloc.dart';
import 'package:breakout_editor/widgets/editor_field.dart';
import 'package:breakout_editor/widgets/menu_speed_dial.dart';
import 'package:breakout_editor/widgets/title_bar.dart';
import 'package:breakout_editor/widgets/tool_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Editor extends StatefulWidget {
  const Editor({Key? key}) : super(key: key);

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditorBloc>(
        create: (context) => EditorBloc(),
        child: Scaffold(
          floatingActionButton: MenuSpeedDial(),
          floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
          backgroundColor: Colors.grey[900],
          body: SafeArea(
              child: Column(children: [
            Expanded(
                child: Stack(children: [
              Center(
                  child: InteractiveViewer(
                      minScale: 1.0,
                      maxScale: 4.0,
                      panEnabled: false,
                      scaleEnabled: true,
                      transformationController: _transformationController,
                      child: Center(child: BlocBuilder<EditorBloc, EditorState>(
                          builder: (context, bloc) {
                        return EditorField(
                          level: bloc.levelData,
                          blockTapCallback: (int blockIndex) {
                            BlocProvider.of<EditorBloc>(context)
                                .add(EditorEventBlockTapped(blockIndex));
                          },
                          canvasDragUpdateCallback:
                              (DragUpdateDetails details) {
                            print("Drag Update: ${details.localPosition}");
                          },
                          canvasTapUpCallback: (TapUpDetails details) {
                            print("Tap Up: ${details.localPosition}");
                          },
                        );
                      })))),
              TitleBar(),
              ToolBar(),
            ]))
          ])),
        ));
  }
}
