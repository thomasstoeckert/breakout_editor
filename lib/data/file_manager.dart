import 'dart:typed_data';

import 'package:breakout_editor/data/level.dart';
import 'package:file_selector/file_selector.dart';
import 'package:path/path.dart';

class FileManager {
  static final List<XTypeGroup> _loadTypeGroups = <XTypeGroup>[
    XTypeGroup(label: "Level Files", extensions: <String>['bol']),
    XTypeGroup(label: "Text Files", extensions: <String>['txt']),
    XTypeGroup(label: "C Header Files", extensions: <String>['h'])
  ];
  static final List<XTypeGroup> _saveTypeGroups = <XTypeGroup>[
    XTypeGroup(label: "Level Files", extensions: <String>['bol'])
  ];

  static Future<Level?> loadFile() async {
    XFile? filePath = await openFile(acceptedTypeGroups: _loadTypeGroups);

    // Load was canceled
    if (filePath == null) return null;

    // Loading data from the file, all as string
    try {
      String stringData = await filePath.readAsString();
      return Level.fromFile(stringData, filePath.path);
    } catch (e) {
      // Error during the encoding process
      print(e);
      throw Exception("Error reading file: $e");
    }
  }

  static Future<bool> saveFile(Level data) async {
    print(data.directory);

    if (data.directory == null) return false;

    // Build the file's path
    String filePath = join(data.directory!, data.filename);

    // Save the file
    final String levelData = data.toCString();
    final Uint8List fileData = Uint8List.fromList(levelData.codeUnits);
    final String mimeType = "text/plain";
    final XFile levelFile = XFile.fromData(fileData, mimeType: mimeType);

    await levelFile.saveTo(filePath);

    data.hasBeenSaved = true;

    return true;
  }

  static Future<String?> saveFileAs(Level data) async {
    // Get the user's requested save path
    String? filePath = await getSavePath(
        acceptedTypeGroups: _saveTypeGroups,
        suggestedName: data.filename,
        initialDirectory: data.directory);

    if (filePath == null) return null;

    // Auto append .txt if we forgot to name the file properly
    if (extension(filePath) == '') {
      filePath += ".bol";
    }

    final String levelData = data.toCString();
    final Uint8List fileData = Uint8List.fromList(levelData.codeUnits);
    final String mimeType = "text/plain";
    final XFile levelFile = XFile.fromData(fileData, mimeType: mimeType);

    await levelFile.saveTo(filePath);

    data.hasBeenSaved = true;
    data.filename = basename(filePath);
    data.directory =
        filePath.substring(0, filePath.length - data.filename.length);

    return filePath;
  }
}
