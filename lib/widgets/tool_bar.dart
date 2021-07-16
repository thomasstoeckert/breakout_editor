import 'package:breakout_editor/bloc/editor_bloc.dart';
import 'package:breakout_editor/data/tool_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToolBar extends StatelessWidget {
  const ToolBar({Key? key}) : super(key: key);

  final double _spreadValue = 35.0;

  void changeToolEvent(
      BuildContext context, ToolMode currentTool, ToolMode newTool) {
    // Check if the new tool is different from the old tool
    bool replacingTool = currentTool != newTool;
    if (replacingTool) {
      context.read<EditorBloc>().add(EditorEventChangeTool(newTool));
    } else {
      context.read<EditorBloc>().add(EditorEventToggleToolPanel());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditorBloc, EditorState>(
      buildWhen: (EditorState oldState, EditorState newState) {
        if (oldState.mode != newState.mode) return true;
        return false;
      },
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
                      isFocused: (state.mode == ToolMode.MOVE),
                      tooltip: "Move",
                      onPressed: () =>
                          changeToolEvent(context, state.mode, ToolMode.MOVE)),
                  SizedBox(
                    width: _spreadValue,
                  ),
                  ToolbarButton(
                    icon: Icons.brush,
                    isFocused: (state.mode == ToolMode.PAINT),
                    tooltip: "Paint",
                    onPressed: () =>
                        changeToolEvent(context, state.mode, ToolMode.PAINT),
                  ),
                  SizedBox(
                    width: _spreadValue,
                  ),
                  ToolbarButton(
                    icon: Icons.add,
                    isFocused: (state.mode == ToolMode.PLACE),
                    tooltip: "Add",
                    onPressed: () =>
                        changeToolEvent(context, state.mode, ToolMode.PLACE),
                  ),
                  SizedBox(
                    width: _spreadValue,
                  ),
                  ToolbarButton(
                    icon: Icons.delete,
                    isFocused: (state.mode == ToolMode.DELETE),
                    tooltip: "Delete",
                    onPressed: () =>
                        changeToolEvent(context, state.mode, ToolMode.DELETE),
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
