import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SaveAsIntent extends Intent {
  const SaveAsIntent();
}

class SaveIntent extends Intent {
  const SaveIntent();
}

class NewIntent extends Intent {
  const NewIntent();
}

class OpenIntent extends Intent {
  const OpenIntent();
}

class Tool1Intent extends Intent {
  const Tool1Intent();
}

class Tool2Intent extends Intent {
  const Tool2Intent();
}

class Tool3Intent extends Intent {
  const Tool3Intent();
}

class Tool4Intent extends Intent {
  const Tool4Intent();
}

class TogglePaneIntent extends Intent {
  const TogglePaneIntent();
}

class ToggleFilePaneIntent extends Intent {
  const ToggleFilePaneIntent();
}

final Map<LogicalKeySet, Intent> shortcutSet = <LogicalKeySet, Intent>{
  LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.shift,
      LogicalKeyboardKey.keyS): const SaveAsIntent(),
  LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS):
      const SaveIntent(),
  LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyN):
      const NewIntent(),
  LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyO):
      const OpenIntent(),
  LogicalKeySet(LogicalKeyboardKey.digit1): const Tool1Intent(),
  LogicalKeySet(LogicalKeyboardKey.keyP): const Tool1Intent(),
  LogicalKeySet(LogicalKeyboardKey.digit2): const Tool2Intent(),
  LogicalKeySet(LogicalKeyboardKey.keyA): const Tool2Intent(),
  LogicalKeySet(LogicalKeyboardKey.digit3): const Tool3Intent(),
  LogicalKeySet(LogicalKeyboardKey.keyD): const Tool3Intent(),
  LogicalKeySet(LogicalKeyboardKey.digit4): const Tool4Intent(),
  LogicalKeySet(LogicalKeyboardKey.keyT): const TogglePaneIntent(),
  LogicalKeySet(LogicalKeyboardKey.alt): const ToggleFilePaneIntent(),
};
