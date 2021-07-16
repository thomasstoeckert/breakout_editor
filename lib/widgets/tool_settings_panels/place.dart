import 'package:breakout_editor/bloc/editor_bloc.dart';
import 'package:breakout_editor/data/tool_settings.dart';
import 'package:breakout_editor/widgets/tool_settings_panel.dart';
import 'package:cyclop/cyclop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TBPanelContentPlace extends StatelessWidget {
  final PlaceToolSettings toolSettings;

  const TBPanelContentPlace(this.toolSettings);

  @override
  Widget build(BuildContext context) {
    return TBPanelContent(
      title: "Place Tool",
      children: [
        ListTile(
          title: Text("Show Preview"),
          trailing: Switch.adaptive(
              value: toolSettings.showPreview,
              onChanged: (value) {
                PlaceToolSettings settings =
                    PlaceToolSettings.from(toolSettings)..showPreview = value;

                BlocProvider.of<EditorBloc>(context).add(
                    EditorEventChangeToolSettings(ToolMode.PLACE, settings));
              }),
        ),
        Divider(),
        ListTile(
          title: Text("Use Grid"),
          trailing: Switch.adaptive(
              value: toolSettings.useToolGrid,
              onChanged: (value) {
                PlaceToolSettings settings =
                    PlaceToolSettings.from(toolSettings)..useToolGrid = value;

                BlocProvider.of<EditorBloc>(context).add(
                    EditorEventChangeToolSettings(ToolMode.PLACE, settings));
              }),
        ),
        ListTile(
          title: Text("Grid Size"),
          trailing: DropdownButton<ToolGridSize>(
            value: toolSettings.toolGridSize,
            items: ToolGridSize.values
                .map((e) => DropdownMenuItem<ToolGridSize>(
                      value: e,
                      child: Text(formatSettingsEnum(e, "GRID_")),
                    ))
                .toList(growable: false),
            onChanged: (value) {
              if (value == null) return;
              PlaceToolSettings settings = PlaceToolSettings.from(toolSettings)
                ..toolGridSize = value;

              BlocProvider.of<EditorBloc>(context)
                  .add(EditorEventChangeToolSettings(ToolMode.PLACE, settings));
            },
          ),
        ),
        Divider(),
        ListTile(
          title: Text("Lock Ratio"),
          trailing: Switch.adaptive(
              value: toolSettings.useToolBlockRatio,
              onChanged: (value) {
                PlaceToolSettings settings =
                    PlaceToolSettings.from(toolSettings)
                      ..useToolBlockRatio = value;

                BlocProvider.of<EditorBloc>(context).add(
                    EditorEventChangeToolSettings(ToolMode.PLACE, settings));
              }),
        ),
        ListTile(
          title: Text("Size Ratio"),
          trailing: DropdownButton<ToolBlockRatio>(
              value: toolSettings.toolBlockRatio,
              items: ToolBlockRatio.values
                  .map((e) => DropdownMenuItem<ToolBlockRatio>(
                        value: e,
                        child: Text(formatSettingsEnum(e, "RATIO_")),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                PlaceToolSettings settings =
                    PlaceToolSettings.from(toolSettings)
                      ..toolBlockRatio = value;

                BlocProvider.of<EditorBloc>(context).add(
                    EditorEventChangeToolSettings(ToolMode.PLACE, settings));
              }),
        ),
        Divider(),
        ListTile(
          title: Text("Default Block Size"),
          trailing: DropdownButton<ToolBlockSize>(
            value: toolSettings.toolBlockSize,
            items: ToolBlockSize.values
                .map((e) => DropdownMenuItem<ToolBlockSize>(
                      value: e,
                      child: Text(formatSettingsEnum(e, "SIZE_")),
                    ))
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              PlaceToolSettings settings = PlaceToolSettings.from(toolSettings)
                ..toolBlockSize = value;

              BlocProvider.of<EditorBloc>(context)
                  .add(EditorEventChangeToolSettings(ToolMode.PLACE, settings));
            },
          ),
        ),
        Divider(),
        ListTile(
          title: Text("Color"),
          trailing: ColorButton(
            color: toolSettings.color,
            onColorChanged: (color) {
              PlaceToolSettings settings = PlaceToolSettings.from(toolSettings)
                ..color = color;

              BlocProvider.of<EditorBloc>(context)
                  .add(EditorEventChangeToolSettings(ToolMode.PLACE, settings));
            },
          ),
        )
      ],
    );
  }
}
