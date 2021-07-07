class Block {
  int leftPos;
  int topPos;

  int width;
  int height;

  factory Block.fromLTWH(int left, int top, int width, int height) {
    return Block(left, top, width, height);
  }

  factory Block.fromDeltaLT(int left, int top, int deltaLeft, int deltaTop) {
    return Block(left, top, deltaLeft - left, deltaTop - top);
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

  Block(this.leftPos, this.topPos, this.width, this.height);

  String toCString() {
    return "{$leftPos, $topPos, ${leftPos + width}, ${topPos + height}}";
  }
}
