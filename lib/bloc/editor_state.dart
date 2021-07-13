part of 'editor_bloc.dart';

abstract class EditorState extends Equatable {
  final Level levelData;
  final ToolSettings toolSettings;

  const EditorState(this.levelData, this.toolSettings);

  @override
  List<Object> get props => [levelData, toolSettings];
}

class EditorFileUnloaded extends EditorState {
  EditorFileUnloaded() : super(Level.empty(), NoToolSettings());
}

class EditorFileLoaded extends EditorState {
  const EditorFileLoaded(Level levelData, ToolSettings toolSettings)
      : super(levelData, toolSettings);
}
