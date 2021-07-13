import 'package:breakout_editor/bloc/editor_bloc.dart';
import 'package:breakout_editor/data/tool_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToolBar extends StatelessWidget {
  const ToolBar({Key? key}) : super(key: key);

  final double _spreadValue = 35.0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditorBloc, EditorState>(
      builder: (context, state) {
        return Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ToolbarButton(
                      icon: Icons.pan_tool,
                      isFocused: (state.toolSettings is MoveToolSettings),
                      onPressed: () => context
                          .read<EditorBloc>()
                          .add(EditorEventChangeTool(MoveToolSettings()))),
                  SizedBox(
                    width: _spreadValue,
                  ),
                  ToolbarButton(
                    icon: Icons.brush,
                    isFocused: (state.toolSettings is PaintToolSettings),
                    onPressed: () => context
                        .read<EditorBloc>()
                        .add(EditorEventChangeTool(PaintToolSettings())),
                  ),
                  SizedBox(
                    width: _spreadValue,
                  ),
                  ToolbarButton(
                    icon: Icons.add,
                    isFocused: (state.toolSettings is PlaceToolSettings),
                    onPressed: () => context
                        .read<EditorBloc>()
                        .add(EditorEventChangeTool(PlaceToolSettings())),
                  ),
                  SizedBox(
                    width: _spreadValue,
                  ),
                  ToolbarButton(
                    icon: Icons.delete,
                    isFocused: (state.toolSettings is DeleteToolSettings),
                    onPressed: () => context
                        .read<EditorBloc>()
                        .add(EditorEventChangeTool(DeleteToolSettings())),
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
  final bool isFocused;

  const ToolbarButton(
      {Key? key, required this.icon, required this.isFocused, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.all(20),
          elevation: isFocused ? 6.0 : null,
          primary:
              isFocused ? Theme.of(context).primaryColor : Colors.grey[700]),
      child: Icon(icon, size: 36.0),
      onPressed: onPressed,
    );
  }
}
