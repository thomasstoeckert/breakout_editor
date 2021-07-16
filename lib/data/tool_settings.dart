import 'package:flutter/material.dart';

enum ToolMode { NO_TOOL, PLACE, MOVE, PAINT, DELETE }

abstract class ToolSettings {
  // Has pretty much nothing
}

class NoToolSettings extends ToolSettings {}

enum ToolGridSize {
  NO_GRID,
  GRID_1x1,
  GRID_8x8,
  GRID_8x8p1,
  GRID_8x20,
  GRID_8x20p1,
  GRID_20x20,
  GRID_20x20p1
}

enum ToolBlockSize { SIZE_1x1, SIZE_8x8, SIZE_8x20, SIZE_20x20 }
enum ToolBlockRatio { RATIO_1x1, RATIO_1x2, RATIO_2x5, RATIO_5x2 }

class PlaceToolSettings extends ToolSettings {
  bool showPreview = false;
  // Grid Size
  bool useToolGrid = false;
  ToolGridSize toolGridSize = ToolGridSize.NO_GRID;
  // Default Block Size
  ToolBlockSize toolBlockSize = ToolBlockSize.SIZE_8x20;
  // Block Aspect Ratio
  bool useToolBlockRatio = false;
  ToolBlockRatio toolBlockRatio = ToolBlockRatio.RATIO_2x5;
  // Paint color
  Color color = Colors.blue;

  PlaceToolSettings();

  factory PlaceToolSettings.from(PlaceToolSettings old) {
    PlaceToolSettings ret = PlaceToolSettings();

    ret.showPreview = old.showPreview;
    ret.useToolGrid = old.useToolGrid;
    ret.toolGridSize = old.toolGridSize;
    ret.toolBlockSize = old.toolBlockSize;
    ret.useToolBlockRatio = old.useToolBlockRatio;
    ret.color = old.color;

    return ret;
  }
}

class MoveToolSettings extends ToolSettings {
  // Grid Size
}

class PaintToolSettings extends ToolSettings {
  // Paint Color
}

class DeleteToolSettings extends ToolSettings {
  // None, as far as I know
}

Map<ToolMode, ToolSettings> defaultSettings = {
  ToolMode.NO_TOOL: NoToolSettings(),
  ToolMode.PLACE: PlaceToolSettings(),
  ToolMode.MOVE: MoveToolSettings(),
  ToolMode.PAINT: PaintToolSettings(),
  ToolMode.DELETE: DeleteToolSettings()
};

String formatSettingsEnum(Object enumval, String prefix) {
  return enumval
      .toString()
      .split(".")
      .last
      .replaceAll(prefix, "")
      .replaceAll("p", "+");
}
