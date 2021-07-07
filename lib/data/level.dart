import 'package:breakout_editor/data/block.dart';

class Level {
  List<Block> levelData;

  Level(this.levelData);

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

  String toCString() {
    // String each of the block's data pieces together
    List<String> blockStrings = <String>[];
    levelData.forEach((element) {
      blockStrings.add(element.toCString());
    });
    return "{${blockStrings.join(", ")}}";
  }
}
