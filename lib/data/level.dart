import 'package:breakout_editor/data/block.dart';

class Level {
  List<Block> levelData;
  String filename;

  Level(this.levelData, {this.filename = "breakout-level"});

  factory Level.fromString(String stringLevelData) {
    // Strip out the first and last brackets
    stringLevelData = stringLevelData.replaceAll(RegExp(r'^\{{1}|\}{1}$'), '');
    // Split the string into invidiual blocks
    List<String> splitData = stringLevelData.split(RegExp(r'\}, '));
    // Create our new levelData list
    List<Block> parsedData = <Block>[];
    // Fill it.
    splitData.forEach((element) {
      parsedData.add(Block.fromCString(element + '}'));
    });

    return Level(parsedData);
  }

  factory Level.fromFile(String stringLevelData, String filename) {
    Level parsed = Level.fromString(stringLevelData);
    parsed.filename = filename;
    return parsed;
  }

  factory Level.empty() {
    return Level(<Block>[]);
  }

  factory Level.fromLevel(Level from) {
    return Level(from.levelData, filename: from.filename);
  }

  String toCString() {
    // String each of the block's data pieces together
    List<String> blockStrings = <String>[];
    levelData.forEach((element) {
      blockStrings.add(element.toCString());
    });
    return "{${blockStrings.join(", ")}}";
  }
}
