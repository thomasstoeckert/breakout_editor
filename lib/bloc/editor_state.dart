part of 'editor_bloc.dart';

abstract class EditorState extends Equatable {
  final Level levelData;
  final ToolSettings toolSettings;
  final bool showToolPanel;

  const EditorState(this.levelData, this.toolSettings, this.showToolPanel);

  @override
  List<Object> get props => [levelData, toolSettings, showToolPanel];
}

class EditorFileUnloaded extends EditorState {
  EditorFileUnloaded() : super(Level.empty(), NoToolSettings(), false);
}

class EditorFileLoaded extends EditorState {
  const EditorFileLoaded(
      Level levelData, ToolSettings toolSettings, bool showToolPanel)
      : super(levelData, toolSettings, showToolPanel);
}
