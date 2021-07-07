import 'package:breakout_editor/pages/editor.dart';
import 'package:flutter/material.dart';

class BreakoutEditor extends StatelessWidget {
  const BreakoutEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Color.fromRGBO(255, 0, 0, 1.0),
          backgroundColor: Color.fromRGBO(95, 97, 95, 1.0),
          cardColor: Color.fromRGBO(139, 147, 170, 1.0),
          accentColor: Color.fromRGBO(190, 61, 82, 1.0),
          canvasColor: Color.fromRGBO(11, 7, 11, 1.0)),
      home: Editor(),
    );
  }
}
