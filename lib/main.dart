import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:breakout_editor/app.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(BreakoutEditor());

  doWhenWindowReady(() {
    final initialSize = Size(900, 600);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.title = "Breakout Editor";
    appWindow.show();
  });
}
