import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class TitleBar extends StatelessWidget {
  TitleBar({Key? key}) : super(key: key);

  final _buttonColors = WindowButtonColors(
      iconNormal: Color(0xFFFFFFFF),
      mouseOver: Color(0xFFB73B4F),
      mouseDown: Color(0xFF832A38),
      iconMouseOver: Colors.white,
      iconMouseDown: Colors.white);

  final _closeButtonColors = WindowButtonColors(
      mouseOver: Color(0xFFD32F2F),
      mouseDown: Color(0xFFB71C1C),
      iconNormal: Colors.white,
      iconMouseOver: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: WindowTitleBarBox(
        child: Row(
          children: [
            Expanded(child: MoveWindow()),
            Row(
              children: [
                MinimizeWindowButton(
                  colors: _buttonColors,
                ),
                MaximizeWindowButton(colors: _buttonColors),
                CloseWindowButton(colors: _closeButtonColors)
              ],
            )
          ],
        ),
      ),
    );
  }
}
