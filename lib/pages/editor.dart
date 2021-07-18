import 'package:breakout_editor/bloc/editor_bloc.dart';
import 'package:breakout_editor/data/key_intents.dart';
import 'package:breakout_editor/data/tool_settings.dart';
import 'package:breakout_editor/widgets/block_counter.dart';
import 'package:breakout_editor/widgets/editor_field.dart';
import 'package:breakout_editor/widgets/menu_speed_dial.dart';
import 'package:breakout_editor/widgets/title_bar.dart';
import 'package:breakout_editor/widgets/tool_bar.dart';
import 'package:breakout_editor/widgets/tool_settings_panel.dart';
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

  void _messageBloc(BuildContext context, EditorEvent event) {
    BlocProvider.of<EditorBloc>(context).add(event);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditorBloc>(
        create: (context) => EditorBloc(),
        child: Shortcuts(
            shortcuts: shortcutSet,
            child: BlocBuilder<EditorBloc, EditorState>(
              builder: (context, state) {
                return Actions(
                    actions: <Type, Action<Intent>>{
                      SaveAsIntent: CallbackAction<SaveAsIntent>(
                          onInvoke: (_) =>
                              _messageBloc(context, EditorEventSaveFileAs())),
                      SaveIntent: CallbackAction<SaveIntent>(
                          onInvoke: (_) =>
                              _messageBloc(context, EditorEventSaveFile())),
                      NewIntent: CallbackAction<NewIntent>(
                          onInvoke: (_) =>
                              _messageBloc(context, EditorEventNewFile())),
                      OpenIntent: CallbackAction<OpenIntent>(
                          onInvoke: (_) =>
                              _messageBloc(context, EditorEventLoadFile())),
                      Tool1Intent: CallbackAction<Tool1Intent>(
                          onInvoke: (_) => _messageBloc(
                              context, EditorEventChangeTool(ToolMode.MOVE))),
                      Tool2Intent: CallbackAction<Tool2Intent>(
                          onInvoke: (_) => _messageBloc(
                              context, EditorEventChangeTool(ToolMode.PAINT))),
                      Tool3Intent: CallbackAction<Tool3Intent>(
                          onInvoke: (_) => _messageBloc(
                              context, EditorEventChangeTool(ToolMode.PLACE))),
                      Tool4Intent: CallbackAction<Tool4Intent>(
                          onInvoke: (_) => _messageBloc(
                              context, EditorEventChangeTool(ToolMode.DELETE))),
                      TogglePaneIntent: CallbackAction<TogglePaneIntent>(
                          onInvoke: (_) => _messageBloc(
                              context, EditorEventToggleToolPanel()))
                    },
                    child: Focus(
                        autofocus: true,
                        child: Scaffold(
                          floatingActionButton: MenuSpeedDial(),
                          floatingActionButtonLocation:
                              FloatingActionButtonLocation.startTop,
                          backgroundColor: Colors.grey[900],
                          body: SafeArea(
                              child: Stack(children: [
                            Center(
                              child: InteractiveViewer(
                                  minScale: 1.0,
                                  maxScale: 4.0,
                                  panEnabled: false,
                                  scaleEnabled: true,
                                  transformationController:
                                      _transformationController,
                                  child: _buildField(context)),
                            ),
                            TitleBar(),
                            ToolBar(),
                            ToolBarSettingsPane(),
                            BlockCounter()
                          ])),
                        )));
              },
            )));
  }

  Widget _buildField(BuildContext context) {
    return Center(
        child: BlocBuilder<EditorBloc, EditorState>(builder: (context, bloc) {
      return EditorField(
        level: bloc.levelData,
        ghostBlock: (bloc.runtimeType == EditorGhostUpdate
            ? (bloc as EditorGhostUpdate).ghostBlock
            : null),
        canvasDragStartCallback: (DragStartDetails details) {
          BlocProvider.of<EditorBloc>(context)
              .add(EditorEventCanvasDragStart(details));
        },
        canvasDragUpdateCallback: (DragUpdateDetails details) {
          BlocProvider.of<EditorBloc>(context)
              .add(EditorEventCanvasDragUpdate(details));
        },
        canvasDragEndCallback: (DragEndDetails details) {
          BlocProvider.of<EditorBloc>(context)
              .add(EditorEventCanvasDragEnd(details));
        },
        canvasTapUpCallback: (TapUpDetails details) {
          // Create simple block
          BlocProvider.of<EditorBloc>(context)
              .add(EditorEventCanvasTapped(details.localPosition));
        },
      );
    }));
  }
}
