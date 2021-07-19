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

class EditorEventChangeTool extends EditorEvent {
  final ToolMode toolMode;

  const EditorEventChangeTool(this.toolMode);

  @override
  List<Object> get props {
    return super.props..add(toolMode);
  }
}

class EditorEventChangeToolSettings extends EditorEvent {
  final ToolMode toolMode;
  final ToolSettings toolSettings;

  const EditorEventChangeToolSettings(this.toolMode, this.toolSettings);

  @override
  List<Object> get props => super.props..addAll([toolMode, toolSettings]);
}

class EditorEventToggleToolPanel extends EditorEvent {
  const EditorEventToggleToolPanel();
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

class EditorEventCursorEnter extends EditorEvent {
  final PointerEvent details;

  const EditorEventCursorEnter(this.details);

  @override
  List<Object> get props => super.props..add(details);
}

class EditorEventCursorExit extends EditorEvent {
  final PointerEvent details;

  const EditorEventCursorExit(this.details);

  @override
  List<Object> get props => super.props..add(details);
}

class EditorEventCursorUpdate extends EditorEvent {
  final PointerEvent details;

  const EditorEventCursorUpdate(this.details);

  @override
  List<Object> get props => super.props..add(details);
}
