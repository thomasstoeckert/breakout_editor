import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:breakout_editor/data/file_manager.dart';
import 'package:breakout_editor/data/level.dart';
import 'package:breakout_editor/data/tool_settings.dart';
import 'package:equatable/equatable.dart';

part 'editor_event.dart';
part 'editor_state.dart';

class EditorBloc extends Bloc<EditorEvent, EditorState> {
  static const _levelString =
      '''{{1, 1, 20, 8}, {22, 1, 42, 8}, {44, 1, 64, 8}, {66, 1, 86, 8}, {88, 1, 108, 8}, {110, 1, 127, 8}, {1, 10, 20, 18}, {22, 10, 42, 18}, {44, 10, 64, 18}, {66, 10, 86, 18}, {88, 10, 108, 18}, {110, 10, 127, 18}, {1, 20, 20, 28}, {22, 20, 42, 28}, {44, 20, 64, 28}, {66, 20, 86, 28}, {88, 20, 108, 28}, {110, 20, 127, 28}, {1, 30, 20, 38}, {22, 30, 42, 38}, {44, 30, 64, 38}, {66, 30, 86, 38}, {88, 30, 108, 38}, {110, 30, 127, 38}, {1, 40, 20, 48}, {22, 40, 42, 48}, {44, 40, 64, 48}, {66, 40, 86, 48}, {88, 40, 108, 48}, {110, 40, 127, 48}}''';

  EditorBloc() : super(EditorFileUnloaded());

  Level _levelData = Level.empty();
  ToolSettings _toolSettings = NoToolSettings();

  @override
  Stream<EditorState> mapEventToState(
    EditorEvent event,
  ) async* {
    if (event is EditorEventLoadFile)
      yield* _mapEditorEventLoadFileToState(event);
    if (event is EditorEventSaveFile)
      yield* _mapEditorEventSaveFileToState(event);
    if (event is EditorEventNewFile)
      yield* _mapEditorEventNewFileToState(event);
    if (event is EditorEventChangeTool)
      yield* _mapEditorEventChangeToolToState(event);
    if (event is EditorEventPlaceBlock)
      yield* _mapEditorEventPlaceBlockToState(event);
    if (event is EditorEventMoveBlock)
      yield* _mapEditorEventMoveBlockToState(event);
    if (event is EditorEventBlockTapped)
      yield* _mapEditorEventBlockTappedToState(event);
  }

  Stream<EditorState> _mapEditorEventLoadFileToState(
      EditorEventLoadFile event) async* {
    // Get our level data from the File Manager
    Level? newLevelData = await FileManager.loadFile();

    // If level data is null, return to the normal state
    if (newLevelData != null) {
      _levelData = newLevelData;
    }

    yield EditorFileLoaded(_levelData, _toolSettings);
  }

  Stream<EditorState> _mapEditorEventSaveFileToState(
      EditorEventSaveFile event) async* {
    // Save our level data with the file manager
    await FileManager.saveFile(_levelData);

    yield EditorFileLoaded(_levelData, _toolSettings);
  }

  Stream<EditorState> _mapEditorEventNewFileToState(
      EditorEventNewFile event) async* {
    _levelData = Level.empty();
    yield EditorFileLoaded(_levelData, _toolSettings);
  }

  Stream<EditorState> _mapEditorEventChangeToolToState(
      EditorEventChangeTool event) async* {
    _toolSettings = event.toolSettings;
    yield EditorFileLoaded(_levelData, _toolSettings);
  }

  Stream<EditorState> _mapEditorEventPlaceBlockToState(
      EditorEventPlaceBlock event) async* {}

  Stream<EditorState> _mapEditorEventMoveBlockToState(
      EditorEventMoveBlock event) async* {}

  Stream<EditorState> _mapEditorEventBlockTappedToState(
      EditorEventBlockTapped event) async* {
    // Behavior changes based upon what tool is used
    if (_toolSettings is PaintToolSettings) {
      // We're going to paint the block
      // TODO: Implement paint
    } else if (_toolSettings is DeleteToolSettings) {
      // We're going to delete the block at that index
      _levelData = Level.fromLevel(_levelData);
      _levelData.levelData.removeAt(event.blockIndex);
    }

    yield EditorFileLoaded(_levelData, _toolSettings);
  }
}
