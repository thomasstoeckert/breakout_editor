part of 'editor_bloc.dart';

abstract class EditorEvent extends Equatable {
  const EditorEvent();

  @override
  List<Object> get props => [];
}

class EditorEventLoadFile extends EditorEvent {
  const EditorEventLoadFile();
}

class EditorEventSaveFile extends EditorEvent {
  const EditorEventSaveFile();
}

class EditorEventNewFile extends EditorEvent {
  const EditorEventNewFile();
}

class EditorEventPlaceBlock extends EditorEvent {
  const EditorEventPlaceBlock();
}

class EditorEventMoveBlock extends EditorEvent {}

class EditorEventChangeTool extends EditorEvent {
  final ToolSettings toolSettings;

  const EditorEventChangeTool(this.toolSettings);

  @override
  List<Object> get props {
    return super.props..add(toolSettings);
  }
}

class EditorEventBlockTapped extends EditorEvent {
  final int blockIndex;

  const EditorEventBlockTapped(this.blockIndex);

  @override
  List<Object> get props => super.props..add(blockIndex);
}

// Events:
// * Load file
// * Save file
// * New file
// * Place block
// * Move block
// * Delete block
// * Paint block
// * Change tool