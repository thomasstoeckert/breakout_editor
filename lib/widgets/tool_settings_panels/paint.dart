import 'package:breakout_editor/bloc/editor_bloc.dart';
import 'package:breakout_editor/data/tool_settings.dart';
import 'package:breakout_editor/widgets/tool_settings_panel.dart';
import 'package:cyclop/cyclop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TBPanelContentPaint extends StatelessWidget {
  final PaintToolSettings toolSettings;
  const TBPanelContentPaint({Key? key, required this.toolSettings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TBPanelContent(
      title: "Paint Tool",
      children: [
        ListTile(
          title: Text("Color"),
          trailing: ColorButton(
            color: toolSettings.color,
            onColorChanged: (Color value) {
              PaintToolSettings settings = PaintToolSettings.from(toolSettings);
              settings.color = value;

              BlocProvider.of<EditorBloc>(context)
                  .add(EditorEventChangeToolSettings(ToolMode.PAINT, settings));
            },
          ),
        )
      ],
    );
  }
}
