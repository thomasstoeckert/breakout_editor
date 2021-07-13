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

class EditorEventSaveFileAs extends EditorEvent {
  const EditorEventSaveFileAs();
}

class EditorEventNewFile extends EditorEvent {
  const EditorEventNewFile();
}

class EditorEventMoveBlock extends EditorEvent {}

class EditorEventChangeTool extends EditorEvent {
  final ToolSettings toolSettings;
  final bool showPanel;

  const EditorEventChangeTool(this.toolSettings, {this.showPanel = false});

  @override
  List<Object> get props {
    return super.props..addAll([toolSettings, showPanel]);
  }
}

class EditorEventBlockTapped extends EditorEvent {
  final int blockIndex;

  const EditorEventBlockTapped(this.blockIndex);

  @override
  List<Object> get props => super.props..add(blockIndex);
}

class EditorEventCanvasTapped extends EditorEvent {
  final Offset tapPosition;

  const EditorEventCanvasTapped(this.tapPosition);

  @override
  List<Object> get props => super.props..add(tapPosition);
}

class EditorEventCanvasDragStart extends EditorEvent {
  final DragStartDetails details;

  const EditorEventCanvasDragStart(this.details);

  @override
  List<Object> get props => super.props..add(details);
}

class EditorEventCanvasDragEnd extends EditorEvent {
  final DragEndDetails details;

  const EditorEventCanvasDragEnd(this.details);

  @override
  List<Object> get props => super.props..add(details);
}

class EditorEventCanvasDragUpdate extends EditorEvent {
  final DragUpdateDetails details;

  const EditorEventCanvasDragUpdate(this.details);

  @override
  List<Object> get props => super.props..add(details);
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