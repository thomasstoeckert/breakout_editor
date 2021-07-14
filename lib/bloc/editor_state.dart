part of 'editor_bloc.dart';

abstract class EditorState extends Equatable {
  final Level levelData;
  final ToolMode mode;
  final Map<ToolMode, ToolSettings> toolSettings;
  final bool showToolPanel;

  const EditorState(
      this.levelData, this.mode, this.toolSettings, this.showToolPanel);

  @override
  List<Object> get props => [levelData, mode, toolSettings, showToolPanel];
}

class EditorFileUnloaded extends EditorState {
  EditorFileUnloaded()
      : super(
            Level.empty(), ToolMode.NO_TOOL, Map.from(defaultSettings), false);
}

class EditorFileLoaded extends EditorState {
  const EditorFileLoaded(Level levelData, ToolMode mode,
      Map<ToolMode, ToolSettings> toolSettings, bool showToolPanel)
      : super(levelData, mode, toolSettings, showToolPanel);
}
