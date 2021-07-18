import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:breakout_editor/data/block.dart';
import 'package:breakout_editor/data/file_manager.dart';
import 'package:breakout_editor/data/level.dart';
import 'package:breakout_editor/data/tool_settings.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'editor_event.dart';
part 'editor_state.dart';

class EditorBloc extends Bloc<EditorEvent, EditorState> {
  EditorBloc() : super(EditorFileUnloaded());

  Level _levelData = Level.empty();

  ToolMode _toolMode = ToolMode.NO_TOOL;
  Map<ToolMode, ToolSettings> _toolSettings = Map.from(defaultSettings);
  bool _showToolpanel = false;

  Block? _workingBlock;
  Offset? _workingOffset;

  Block? _previewBlock;

  @override
  Stream<EditorState> mapEventToState(
    EditorEvent event,
  ) async* {
    // File Events
    if (event is EditorEventLoadFile)
      yield* _mapEditorEventLoadFileToState(event);
    if (event is EditorEventSaveFile)
      yield* _mapEditorEventSaveFileToState(event);
    if (event is EditorEventSaveFileAs)
      yield* _mapEditorEventSaveFileAsToState(event);
    if (event is EditorEventNewFile)
      yield* _mapEditorEventNewFileToState(event);

    // Tool Settings Events
    if (event is EditorEventChangeTool)
      yield* _mapEditorEventChangeToolToState(event);
    if (event is EditorEventChangeToolSettings)
      yield* _mapEditorEventChangeToolSettings(event);
    if (event is EditorEventToggleToolPanel)
      yield* _mapEditorEventToggleToolPanel(event);

    // Block Interaction Events
    if (event is EditorEventCanvasTapped)
      yield* _mapEditorEventCanvasTappedToState(event);
    if (event is EditorEventCanvasDragStart)
      yield* _mapEditorEventCanvasDragStartToState(event);
    if (event is EditorEventCanvasDragUpdate)
      yield* _mapEditorEventCanvasDragUpdateToState(event);
    if (event is EditorEventCanvasDragEnd)
      yield* _mapEditorEventCanvasDragEndToState(event);

    // Cursor Events
    if (event is EditorEventCursorEnter)
      yield* _mapEditorEventCursorEnterToState(event);
    if (event is EditorEventCursorExit)
      yield* _mapEditorEventCursorExitToState(event);
    if (event is EditorEventCursorUpdate)
      yield* _mapEditorEventCursorUpdateToState(event);
  }

  Stream<EditorState> _mapEditorEventLoadFileToState(
      EditorEventLoadFile event) async* {
    // Get our level data from the File Manager
    Level? newLevelData = await FileManager.loadFile();

    // If level data is null, return to the normal state
    if (newLevelData != null) {
      _levelData = newLevelData;
    }

    _levelData.hasBeenSaved = true;
    yield EditorFileLoaded(
        _levelData, _toolMode, _toolSettings, _showToolpanel);
  }

  Stream<EditorState> _mapEditorEventSaveFileToState(
      EditorEventSaveFile event) async* {
    // Attempt to save the file in the provided directory / filename
    await FileManager.saveFile(_levelData);

    _levelData = Level.fromLevel(_levelData);

    yield EditorFileLoaded(
        _levelData, _toolMode, _toolSettings, _showToolpanel);
  }

  Stream<EditorState> _mapEditorEventSaveFileAsToState(
      EditorEventSaveFileAs event) async* {
    // Save our level data with the file manager
    await FileManager.saveFileAs(_levelData);

    _levelData = Level.fromLevel(_levelData);

    yield EditorFileLoaded(
        _levelData, _toolMode, _toolSettings, _showToolpanel);
  }

  Stream<EditorState> _mapEditorEventNewFileToState(
      EditorEventNewFile event) async* {
    _levelData = Level.empty();
    yield EditorFileLoaded(
        _levelData, _toolMode, _toolSettings, _showToolpanel);
  }

  Stream<EditorState> _mapEditorEventChangeToolToState(
      EditorEventChangeTool event) async* {
    print("Change tool event: old: $_toolMode, new: ${event.toolMode}");
    _toolMode = event.toolMode;
    yield EditorFileLoaded(
        _levelData, _toolMode, _toolSettings, _showToolpanel);
  }

  Stream<EditorState> _mapEditorEventChangeToolSettings(
      EditorEventChangeToolSettings event) async* {
    // Build our new ToolSettings map
    _toolSettings = Map.of(_toolSettings);
    // Update the map's relevant toolSettings
    _toolSettings[event.toolMode] = event.toolSettings;

    yield EditorFileLoaded(
        _levelData, _toolMode, _toolSettings, _showToolpanel);
  }

  Stream<EditorState> _mapEditorEventToggleToolPanel(
      EditorEventToggleToolPanel event) async* {
    _showToolpanel = !_showToolpanel;
    yield EditorFileLoaded(
        _levelData, _toolMode, _toolSettings, _showToolpanel);
  }

  Stream<EditorState> _mapEditorEventCanvasTappedToState(
      EditorEventCanvasTapped event) async* {
    // Only function if we're using the place tool
    if (_toolMode == ToolMode.PLACE) {
      // Check to see if there's a block already in that spot
      Block? matchingBlock;
      for (Block block in _levelData.levelData) {
        if (block.isPointInBlock(event.tapPosition.dx, event.tapPosition.dy)) {
          matchingBlock = block;
          break;
        }
      }

      // If there is a block, cancel.
      if (matchingBlock != null) return;

      Block newBlock = (_toolSettings[_toolMode] as PlaceToolSettings)
          .createBlock(event.tapPosition.dx.toInt(),
              event.tapPosition.dy.toInt(), null, null);

      _levelData = Level.fromLevel(_levelData);
      _levelData.levelData.add(newBlock);
      _levelData.hasBeenSaved = false;
    }

    if (_toolMode == ToolMode.DELETE) {
      // Find the first block at that position
      Block? matchingBlock;
      Offset localPosition = event.tapPosition;

      for (Block block in _levelData.levelData) {
        if (block.isPointInBlock(localPosition.dx, localPosition.dy)) {
          matchingBlock = block;
          break;
        }
      }

      if (matchingBlock != null) {
        _levelData = Level.fromLevel(_levelData);
        _levelData.levelData.remove(matchingBlock);
        _levelData.hasBeenSaved = false;
      }
    }

    yield EditorFileLoaded(
        _levelData, _toolMode, _toolSettings, _showToolpanel);
  }

  Stream<EditorState> _mapEditorEventCanvasDragStartToState(
      EditorEventCanvasDragStart event) async* {
    // We're beginning a drag. Create a block, keep a refrence to it in the bloc,
    // and place it in the world.
    if (_toolMode == ToolMode.PLACE) {
      // Create the block
      Block sizedBlock = (_toolSettings[_toolMode] as PlaceToolSettings)
          .createBlock(event.details.localPosition.dx.toInt(),
              event.details.localPosition.dy.toInt(), 0, 0);

      _workingOffset = Offset(0, 0);

      // Add that to our level
      _levelData.levelData.add(sizedBlock);

      // Track it here
      _workingBlock = sizedBlock;

      // Update the level
      _levelData = Level.fromLevel(_levelData);
      _levelData.hasBeenSaved = false;
    }

    yield EditorFileLoaded(
        _levelData, _toolMode, _toolSettings, _showToolpanel);
  }

  Stream<EditorState> _mapEditorEventCanvasDragUpdateToState(
      EditorEventCanvasDragUpdate event) async* {
    // We're working on a drag. Update the size of the block, update the level
    if (_toolMode == ToolMode.PLACE && _workingBlock != null) {
      // Get the block
      Block targetBlock = _workingBlock!;

      // Add our changes to our tracked delta
      Offset delta = event.details.delta;
      _workingOffset = _workingOffset! + delta;

      Offset currentSettings = Offset(_workingOffset!.dx, _workingOffset!.dy);
      currentSettings = (_toolSettings[_toolMode] as PlaceToolSettings)
          .clampSizeToSettings(currentSettings);

      // Adjust our target block's size, clamping values as to not flow negative
      // (or out of bounds)
      targetBlock.width =
          currentSettings.dx.toInt().clamp(0, 128 - targetBlock.leftPos);
      targetBlock.height =
          currentSettings.dy.toInt().clamp(0, 128 - targetBlock.topPos);

      // Update the level
      _levelData = Level.fromLevel(_levelData);
      _levelData.hasBeenSaved = false;
    }

    yield EditorFileLoaded(
        _levelData, _toolMode, _toolSettings, _showToolpanel);
  }

  Stream<EditorState> _mapEditorEventCanvasDragEndToState(
      EditorEventCanvasDragEnd event) async* {
    // The drag is complete. Disconnect from the working block.
    if (_toolMode == ToolMode.PLACE && _workingBlock != null) {
      // If the working block has a size of zero in either axis, then
      // it's useless. We need to delete it.
      if (_workingBlock!.width == 0 || _workingBlock!.height == 0) {
        // Remove the working block from the level
        _levelData.levelData.remove(_workingBlock!);
        // Update the level
        _levelData = Level.fromLevel(_levelData);
        _levelData.hasBeenSaved = false;
      }

      // Disconnect from the block
      _workingBlock = null;
      _workingOffset = null;
    }

    yield EditorFileLoaded(
        _levelData, _toolMode, _toolSettings, _showToolpanel);
  }

  Stream<EditorState> _mapEditorEventCursorEnterToState(
      EditorEventCursorEnter event) async* {
    // Check if we're in a mode that has preview support
    if (_toolMode == ToolMode.PLACE && _previewBlock == null) {
      PlaceToolSettings pts =
          _toolSettings[ToolMode.PLACE] as PlaceToolSettings;
      if (pts.showPreview) {
        // Get our cursor position
        Offset localPosition = event.details.localPosition;
        // We need to create a preview block
        _previewBlock = (_toolSettings[_toolMode] as PlaceToolSettings)
            .createBlock(
                localPosition.dx.toInt(), localPosition.dy.toInt(), null, null,
                ghost: true);
        /* _previewBlock = Block(
            localPosition.dx.toInt(), localPosition.dy.toInt(), 20, 8,
            ghost: true); */

        // Update the state
        yield EditorGhostUpdate(_levelData, _toolMode, _toolSettings,
            _showToolpanel, _previewBlock!);
      }
    }
  }

  Stream<EditorState> _mapEditorEventCursorExitToState(
      EditorEventCursorExit event) async* {
    if (_toolMode == ToolMode.PLACE && _previewBlock != null) {
      _previewBlock = null;
      yield EditorFileLoaded(
          _levelData, _toolMode, _toolSettings, _showToolpanel);
    }
  }

  Stream<EditorState> _mapEditorEventCursorUpdateToState(
      EditorEventCursorUpdate event) async* {
    if (_toolMode == ToolMode.PLACE) {
      PlaceToolSettings pts = _toolSettings[_toolMode] as PlaceToolSettings;
      if (pts.showPreview) {
        Offset localPosition = event.details.localPosition;
        _previewBlock = (_toolSettings[_toolMode] as PlaceToolSettings)
            .createBlock(
                localPosition.dx.toInt(), localPosition.dy.toInt(), null, null,
                ghost: true);
        yield EditorGhostUpdate(_levelData, _toolMode, _toolSettings,
            _showToolpanel, _previewBlock!);
      }
    }
  }
}
