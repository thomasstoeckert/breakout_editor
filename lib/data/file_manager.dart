import 'dart:typed_data';

import 'package:breakout_editor/data/level.dart';
import 'package:file_selector/file_selector.dart';

class FileManager {
  static Future<Level?> loadFile() async {
    XFile? filePath = await openFile();

    // Load was canceled
    if (filePath == null) return null;

    // Loading data from the file, all as string
    try {
      String stringData = await filePath.readAsString();
      return Level.fromString(stringData);
    } catch (e) {
      // Error during the encoding process
      throw Exception("Error reading file: $e");
    }
  }

  static Future<bool> saveFile(Level data) async {
    // Get the user's requested save path
    final String? filePath = await getSavePath();

    if (filePath == null) return false;

    final String levelData = data.toCString();
    final Uint8List fileData = Uint8List.fromList(levelData.codeUnits);
    final String mimeType = "text/plain";
    final XFile levelFile = XFile.fromData(fileData, mimeType: mimeType);

    await levelFile.saveTo(filePath);

    return true;
  }
}
