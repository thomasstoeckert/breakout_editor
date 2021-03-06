import 'package:breakout_editor/bloc/editor_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class MenuSpeedDial extends StatelessWidget {
  final ValueNotifier<bool>? openCloseDial;

  const MenuSpeedDial({Key? key, this.openCloseDial}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: SpeedDial(
        tooltip: "File...",
        label: BlocBuilder<EditorBloc, EditorState>(
          builder: (context, state) {
            return Text(state.levelData.getDisplayName());
          },
        ),
        openCloseDial: openCloseDial,
        icon: Icons.description,
        renderOverlay: false,
        direction: SpeedDialDirection.Down,
        switchLabelPosition: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        spacing: 8.0,
        children: [
          SpeedDialChild(
              label: "New File",
              child: Icon(Icons.add),
              onTap: () => BlocProvider.of<EditorBloc>(context)
                  .add(EditorEventNewFile())),
          SpeedDialChild(
              label: "Open File...",
              child: Icon(Icons.folder_open),
              onTap: () => BlocProvider.of<EditorBloc>(context)
                  .add(EditorEventLoadFile())),
          SpeedDialChild(
              label: "Save File",
              child: Icon(Icons.save),
              onTap: () => BlocProvider.of<EditorBloc>(context)
                  .add(EditorEventSaveFile())),
          SpeedDialChild(
              label: "Save File As...",
              child: Icon(Icons.save_alt),
              onTap: () => BlocProvider.of<EditorBloc>(context)
                  .add(EditorEventSaveFileAs()))
        ],
      ),
      padding: const EdgeInsets.only(top: 16.0),
    );
  }
}
