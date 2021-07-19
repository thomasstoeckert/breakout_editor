import 'package:flutter/material.dart';

class Block {
  int leftPos;
  int topPos;

  int width;
  int height;

  bool ghost;
  Color color = Colors.blue;

  factory Block.fromLTWH(int left, int top, int width, int height) {
    return Block(
        left, top, width.clamp(0, 128 - left), height.clamp(0, 128 - top));
  }

  factory Block.fromDeltaLT(int left, int top, int deltaLeft, int deltaTop) {
    return Block(left, top, (deltaLeft - left).clamp(0, 128 - left),
        (deltaTop - top).clamp(0, 128 - top));
  }

  factory Block.fromCString(String cString) {
    // Strip out {}
    cString = cString.replaceAll(RegExp(r'\{|\}'), '');
    // Split into values
    List<String> splitValues = cString.split(", ");
    // Build our block from the string values
    Block formatted = Block.fromDeltaLT(
        int.parse(splitValues[0]),
        int.parse(splitValues[1]),
        int.parse(splitValues[2]),
        int.parse(splitValues[3]));

    return formatted;
  }

  Block(this.leftPos, this.topPos, this.width, this.height,
      {this.ghost = false});

  bool isPointInBlock(num x, num y) {
    if (this.leftPos <= x.toInt() &&
        this.leftPos + this.width >= x.toInt() &&
        this.topPos <= y.toInt() &&
        this.topPos + this.height >= y.toInt()) {
      return true;
    }
    return false;
  }

  String toCString() {
    return "{$leftPos, $topPos, ${leftPos + width}, ${topPos + height}}";
  }

  @override
  String toString() {
    return "Block ($leftPos, $topPos, ${leftPos + width}, ${topPos + height})";
  }
}
