enum ToolMode { NO_TOOL, PLACE, MOVE, PAINT, DELETE }

abstract class ToolSettings {
  // Has pretty much nothing
}

class NoToolSettings extends ToolSettings {}

class PlaceToolSettings extends ToolSettings {
  // Grid Size
  // Default Block Size
  // Block Aspect Ratio
  // Paint color
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
