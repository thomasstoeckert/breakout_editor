import 'package:breakout_editor/pages/editor.dart';
import 'package:flutter/material.dart';

class BreakoutEditor extends StatelessWidget {
  const BreakoutEditor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
      home: Editor(),
    );
  }
}
