import 'package:breakout_editor/bloc/editor_bloc.dart';
import 'package:breakout_editor/data/tool_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToolBar extends StatelessWidget {
  const ToolBar({Key? key}) : super(key: key);

  final double _spreadValue = 35.0;

  void changeToolEvent(
      BuildContext context, EditorState state, ToolSettings newTool) {
    // Check if the new tool is different from the old tool
    bool replacingTool = state.toolSettings.runtimeType != newTool.runtimeType;
    if (replacingTool) {
      context
          .read<EditorBloc>()
          .add(EditorEventChangeTool(newTool, showPanel: state.showToolPanel));
    } else {
      context.read<EditorBloc>().add(EditorEventChangeTool(state.toolSettings,
          showPanel: !state.showToolPanel));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditorBloc, EditorState>(
      builder: (context, state) {
        return Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ToolbarButton(
                      icon: Icons.pan_tool,
                      isFocused: (state.toolSettings is MoveToolSettings),
                      tooltip: "Move",
                      onPressed: () =>
                          changeToolEvent(context, state, MoveToolSettings())),
                  SizedBox(
                    width: _spreadValue,
                  ),
                  ToolbarButton(
                    icon: Icons.brush,
                    isFocused: (state.toolSettings is PaintToolSettings),
                    tooltip: "Paint",
                    onPressed: () =>
                        changeToolEvent(context, state, PaintToolSettings()),
                  ),
                  SizedBox(
                    width: _spreadValue,
                  ),
                  ToolbarButton(
                    icon: Icons.add,
                    isFocused: (state.toolSettings is PlaceToolSettings),
                    tooltip: "Add",
                    onPressed: () =>
                        changeToolEvent(context, state, PlaceToolSettings()),
                  ),
                  SizedBox(
                    width: _spreadValue,
                  ),
                  ToolbarButton(
                    icon: Icons.delete,
                    isFocused: (state.toolSettings is DeleteToolSettings),
                    tooltip: "Delete",
                    onPressed: () =>
                        changeToolEvent(context, state, DeleteToolSettings()),
                  )
                ],
              ),
            ));
      },
    );
  }
}

class ToolbarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final bool isFocused;
  final String? tooltip;

  const ToolbarButton(
      {Key? key,
      required this.icon,
      required this.isFocused,
      this.onPressed,
      this.onLongPress,
      this.tooltip})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      preferBelow: true,
      waitDuration: const Duration(milliseconds: 750),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(20),
            elevation: isFocused ? 6.0 : null,
            primary:
                isFocused ? Theme.of(context).primaryColor : Colors.grey[700]),
        child: Icon(icon, size: 36.0),
        onPressed: onPressed,
        onLongPress: onLongPress,
      ),
      message: tooltip ?? "Toolbar Button",
    );
  }
}
