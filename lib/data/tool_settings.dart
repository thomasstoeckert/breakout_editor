import 'package:breakout_editor/data/block.dart';
import 'package:flutter/material.dart';

enum ToolMode { NO_TOOL, PLACE, MOVE, PAINT, DELETE }

abstract class ToolSettings {
  // Has pretty much nothing
}

class NoToolSettings extends ToolSettings {}

enum ToolGridSize {
  GRID_1x1,
  GRID_8x8,
  GRID_8x16,
  GRID_16x16,
}

enum ToolBlockSize { SIZE_1x1, SIZE_8x8, SIZE_8x16, SIZE_16x16 }
enum ToolBlockRatio { RATIO_1x1, RATIO_1x2, RATIO_2x1 }

class PlaceToolSettings extends ToolSettings {
  bool showPreview = false;
  // Grid Size
  bool useToolGrid = false;
  ToolGridSize toolGridSize = ToolGridSize.GRID_1x1;
  // Default Block Size
  ToolBlockSize toolBlockSize = ToolBlockSize.SIZE_8x16;
  // Block Aspect Ratio
  bool useToolBlockRatio = false;
  ToolBlockRatio toolBlockRatio = ToolBlockRatio.RATIO_2x1;
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

  Block createBlock(int fromLeft, int fromTop, int? width, int? height,
      {bool ghost = false}) {
    // Attempt to create a block from the current settings, based on the above params
    // Step 1: Position
    int finalLeft = fromLeft, finalTop = fromTop;
    if (this.useToolGrid) {
      switch (toolGridSize) {
        case ToolGridSize.GRID_1x1:
          finalLeft = fromLeft;
          finalTop = fromTop;
          break;
        case ToolGridSize.GRID_8x8:
          finalLeft = (fromLeft ~/ 8) * 8;
          finalTop = (fromTop ~/ 8) * 8;
          break;
        /*
        case ToolGridSize.GRID_8x8p1:
          // TODO: Handle this case.
          break;*/
        case ToolGridSize.GRID_8x16:
          finalLeft = (fromLeft ~/ 16) * 16;
          finalTop = (fromTop ~/ 8) * 8;
          break;
        /* case ToolGridSize.GRID_8x20p1:
          // TODO: Handle this case.
          break; */
        case ToolGridSize.GRID_16x16:
          finalLeft = (fromLeft ~/ 16) * 16;
          finalTop = (fromTop ~/ 16) * 16;
          break;
        /* case ToolGridSize.GRID_20x20p1:
          // TODO: Handle this case.
          break; */
        default:
          finalLeft = fromLeft;
          finalTop = fromTop;
          break;
      }
    }

    int finalWidth = 1, finalHeight = 1;
    if (height == null || width == null) {
      // We want to use the default block sizes
      switch (this.toolBlockSize) {
        case ToolBlockSize.SIZE_8x8:
          finalWidth = finalHeight = 8;
          break;
        case ToolBlockSize.SIZE_8x16:
          finalWidth = 16;
          finalHeight = 8;
          break;
        case ToolBlockSize.SIZE_16x16:
          finalWidth = finalHeight = 16;
          break;
        case ToolBlockSize.SIZE_1x1:
          finalWidth = finalHeight = 1;
          break;
      }
    }

    Color finalColor = this.color;
    Block ret = Block.fromLTWH(finalLeft, finalTop, finalWidth, finalHeight);
    ret.ghost = ghost;
    //ret.color = finalColor; TODO: Add color
    return ret;
  }

  // With the given offset, return an offset that is fit to the ratio settings (clamped)
  Offset clampSizeToSettings(Offset givenSize) {
    if (!this.useToolBlockRatio) return givenSize;

    double ratio;
    switch (this.toolBlockRatio) {
      case ToolBlockRatio.RATIO_1x1:
        ratio = 1.0;
        break;
      case ToolBlockRatio.RATIO_1x2:
        ratio = 0.5;
        break;
      case ToolBlockRatio.RATIO_2x1:
        ratio = 2.0;
        break;
    }

    Offset toReturn;
    if (givenSize.dx < givenSize.dy * ratio) {
      // Width is shorter than height
      // w = w, h = w / r
      toReturn = Offset(givenSize.dx, givenSize.dx / ratio);
    } else {
      // Height is shorter than width
      // w = r * h, h = h
      toReturn = Offset(givenSize.dy * ratio, givenSize.dy);
    }

    return toReturn;
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
