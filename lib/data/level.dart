import 'package:breakout_editor/data/block.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

const int LEVEL_CAP = 30;

class Level {
  List<Block> levelData;
  String filename;
  String? directory;
  bool hasBeenSaved;

  Level(this.levelData,
      {this.filename = "Untitled", this.hasBeenSaved = false, this.directory});

  factory Level.fromString(String stringLevelData) {
    // First, split the level by its newlines
    List<String> splitLines = stringLevelData.split('\n');
    // If the level has multiple lines, it is of the new (color) format.
    bool isColor = splitLines.length > 1;
    // If it does not, we treat it normally.

    String blockData = splitLines[0];
    // Strip out the first and last brackets
    blockData = blockData.replaceAll(RegExp(r'^\{{1}|\}{1}$'), '');
    // Split the string into invidiual blocks
    List<String> splitData = blockData.split(RegExp(r'\}, '));
    // Create our new levelData list
    List<Block> parsedData = <Block>[];
    // Fill it.
    splitData.forEach((element) {
      parsedData.add(Block.fromCString(element + '}'));
    });

    if (isColor) {
      // We should process color logic - the second line is palatte data, then
      // the third line is color bindings - which block has what color.
      List<Color> palette = <Color>[];
      String paletteString = splitLines[1];

      // Strip leading & trailing brackets
      paletteString = paletteString.replaceAll(RegExp(r'\{|\}'), '');
      // Split into substrings
      List<String> splitColors = paletteString.split(', ');
      for (String colorString in splitColors) {
        palette.add(_colorFromMSPColor(colorString));
      }

      // Next up is the bindings - what block has what color.
      String bindingString = splitLines[2];
      // Strip leading & trailing brackets
      bindingString = bindingString.replaceAll(RegExp(r'\{|\}'), '');
      List<String> splitBindings = bindingString.split(', ');
      for (int i = 0; i < splitBindings.length; i++) {
        // Binding the block at index i's color to the color in the palette at
        // index splitBindings[i]
        parsedData[i].color = palette[int.parse(splitBindings[i])];
      }
    }

    return Level(parsedData);
  }

  factory Level.fromFile(String stringLevelData, String path) {
    Level parsed = Level.fromString(stringLevelData);
    parsed.filename = basename(path);
    parsed.directory = path.substring(0, path.length - parsed.filename.length);
    return parsed;
  }

  factory Level.empty() {
    return Level(<Block>[]);
  }

  factory Level.fromLevel(Level from) {
    return Level(from.levelData,
        filename: from.filename,
        hasBeenSaved: from.hasBeenSaved,
        directory: from.directory);
  }

  String toCString({bool useColor = true}) {
    // String each of the block's data pieces together
    List<String> blockStrings = <String>[];
    List<Color> colorPalette = <Color>[];
    List<int> colorBindings = <int>[];

    for (int i = 0; i < levelData.length; i++) {
      // Serialize the block's coords
      blockStrings.add(levelData[i].toCString());
      // Get the color, add it to the set
      if (!colorPalette.contains(levelData[i].color))
        colorPalette.add(levelData[i].color);
      // Record the index in the color palette
      colorBindings.add(colorPalette.indexOf(levelData[i].color));
    }

    String blockData = "{${blockStrings.join(", ")}}";
    if (!useColor) return blockData;

    List<String> formattedColors = <String>[];
    colorPalette.forEach((element) {
      formattedColors.add(_colorToMSPColor(element));
    });
    String colorData = "{${formattedColors.join(', ')}}";

    List<String> formattedBinding = <String>[];
    colorBindings.forEach((element) {
      formattedBinding.add(element.toString());
    });

    String bindingData = "{${formattedBinding.join(', ')}}";

    return "$blockData\n$colorData\n$bindingData";
  }

  String getDisplayName() {
    return "$filename${hasBeenSaved ? "" : "*"}";
  }

  Block? getBlockAtPoint(int x, int y) {
    for (Block block in levelData) {
      if (block.isPointInBlock(x, y)) return block;
    }
  }

  static Color _colorFromMSPColor(String mspColor) {
    // The MSP430 graphics library keeps the first two bytes as 00, while
    // flutter would interpret that as invisible. We need to make it... visible.
    int color = int.parse(mspColor) | 0xFF000000;
    return Color(color);
  }

  static String _colorToMSPColor(Color color) {
    // MSP430 has the first two bytes equal to zero - logically AND that with
    // our value to yield the appropriate conversion.
    // This, in effect, takes out the alpha values.
    int colorValue = color.value & 0x00FFFFFF;
    return "0x" + colorValue.toRadixString(16).toUpperCase();
  }
}
