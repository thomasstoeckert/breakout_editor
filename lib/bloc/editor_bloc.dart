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
  static const _levelString =
      '''{{1, 1, 20, 8}, {22, 1, 42, 8}, {44, 1, 64, 8}, {66, 1, 86, 8}, {88, 1, 108, 8}, {110, 1, 127, 8}, {1, 10, 20, 18}, {22, 10, 42, 18}, {44, 10, 64, 18}, {66, 10, 86, 18}, {88, 10, 108, 18}, {110, 10, 127, 18}, {1, 20, 20, 28}, {22, 20, 42, 28}, {44, 20, 64, 28}, {66, 20, 86, 28}, {88, 20, 108, 28}, {110, 20, 127, 28}, {1, 30, 20, 38}, {22, 30, 42, 38}, {44, 30, 64, 38}, {66, 30, 86, 38}, {88, 30, 108, 38}, {110, 30, 127, 38}, {1, 40, 20, 48}, {22, 40, 42, 48}, {44, 40, 64, 48}, {66, 40, 86, 48}, {88, 40, 108, 48}, {110, 40, 127, 48}}''';

  EditorBloc() : super(EditorFileUnloaded());

  Level _levelData = Level.empty();
  ToolSettings _toolSettings = NoToolSettings();
  Block? _workingBlock;
  Offset? _workingOffset;

  @override
  Stream<EditorState> mapEventToState(
    EditorEvent event,
  ) async* {
    // File Events
    if (event is EditorEventLoadFile)
      yield* _mapEditorEventLoadFileToState(event);
    if (event is EditorEventSaveFile)
      yield* _mapEditorEventSaveFileToState(event);
    if (event is EditorEventNewFile)
      yield* _mapEditorEventNewFileToState(event);

    // Tool Settings Events
    if (event is EditorEventChangeTool)
      yield* _mapEditorEventChangeToolToState(event);

    // Block Interaction Events
    if (event is EditorEventMoveBlock)
      yield* _mapEditorEventMoveBlockToState(event);
    if (event is EditorEventBlockTapped)
      yield* _mapEditorEventBlockTappedToState(event);
    if (event is EditorEventCanvasTapped)
      yield* _mapEditorEventCanvasTappedToState(event);
    if (event is EditorEventCanvasDragStart)
      yield* _mapEditorEventCanvasDragStartToState(event);
    if (event is EditorEventCanvasDragUpdate)
      yield* _mapEditorEventCanvasDragUpdateToState(event);
    if (event is EditorEventCanvasDragEnd)
      yield* _mapEditorEventCanvasDragEndToState(event);
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

  Stream<EditorState> _mapEditorEventCanvasTappedToState(
      EditorEventCanvasTapped event) async* {
    // Only function if we're using the place tool
    if (_toolSettings is PlaceToolSettings) {
      Block newBlock = Block.fromLTWH(
          event.tapPosition.dx.toInt(), event.tapPosition.dy.toInt(), 20, 8);

      _levelData = Level.fromLevel(_levelData);
      _levelData.levelData.add(newBlock);
    }

    yield EditorFileLoaded(_levelData, _toolSettings);
  }

  Stream<EditorState> _mapEditorEventCanvasDragStartToState(
      EditorEventCanvasDragStart event) async* {
    // We're beginning a drag. Create a block, keep a refrence to it in the bloc,
    // and place it in the world.
    if (_toolSettings is PlaceToolSettings) {
      // Create the block
      Block sizedBlock = Block.fromLTWH(event.details.localPosition.dx.toInt(),
          event.details.localPosition.dy.toInt(), 0, 0);

      _workingOffset = Offset(0, 0);

      // Add that to our level
      _levelData.levelData.add(sizedBlock);

      // Track it here
      _workingBlock = sizedBlock;

      // Update the level
      _levelData = Level.fromLevel(_levelData);
    }

    yield EditorFileLoaded(_levelData, _toolSettings);
  }

  Stream<EditorState> _mapEditorEventCanvasDragUpdateToState(
      EditorEventCanvasDragUpdate event) async* {
    // We're working on a drag. Update the size of the block, update the level
    if (_toolSettings is PlaceToolSettings && _workingBlock != null) {
      // Get the block
      Block targetBlock = _workingBlock!;

      // Add our changes to our tracked delta
      Offset delta = event.details.delta;
      _workingOffset = _workingOffset! + delta;

      // Adjust our target block's size, clamping values as to not flow negative
      // (or out of bounds)
      targetBlock.width =
          _workingOffset!.dx.toInt().clamp(0, 128 - targetBlock.leftPos);
      targetBlock.height =
          _workingOffset!.dy.toInt().clamp(0, 128 - targetBlock.topPos);

      // Update the level
      _levelData = Level.fromLevel(_levelData);
    }

    yield EditorFileLoaded(_levelData, _toolSettings);
  }

  Stream<EditorState> _mapEditorEventCanvasDragEndToState(
      EditorEventCanvasDragEnd event) async* {
    // The drag is complete. Disconnect from the working block.
    if (_toolSettings is PlaceToolSettings && _workingBlock != null) {
      // Disconnect from the block
      _workingBlock = null;
      _workingOffset = null;
    }
  }
}
