import 'package:breakout_editor/data/block.dart';
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

  String toCString() {
    // String each of the block's data pieces together
    List<String> blockStrings = <String>[];
    levelData.forEach((element) {
      blockStrings.add(element.toCString());
    });
    return "{${blockStrings.join(", ")}}";
  }

  String getDisplayName() {
    return "$filename${hasBeenSaved ? "" : "*"}";
  }
}
