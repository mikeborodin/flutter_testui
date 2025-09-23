List<String> column({
  required List<List<String>> children,
  required int height,
  required int width,
}) {
  List<String> columns = List.generate(width, (_) => '');

  for (int j = 0; j < width; j++) {
    for (int i = 0; i < children.length; i++) {
      final child = children[i];
      final childHeight = (height / children.length).toInt();
      final content = child.length > j ? child[j] : '';
      final truncatedContent = content.length > childHeight && childHeight > 3
          ? '${content.substring(0, childHeight - 3)}...'
          : content.padRight(childHeight);

      columns[j] += truncatedContent;

      if (i < children.length - 1) {
        columns[j] += '\u2502'; // Add vertical separator
      }
    }
  }

  // Ensure the columns respect the specified height
  if (columns.length < height) {
    columns.addAll(List.generate(height - columns.length, (_) => ' ' * width));
  } else if (columns.length > height) {
    columns = columns.sublist(0, height);
  }

  return columns;
}

List<String> verticalPadding({
  required List<String> child,
  required int height,
  required int width,
  int top = 0,
  int bottom = 0,
}) {
  List<String> paddedContent = [];
  for (int i = 0; i < top; i++) {
    paddedContent.add(' ' * width);
  }
  paddedContent.addAll(child);
  for (int i = 0; i < bottom; i++) {
    paddedContent.add(' ' * width);
  }
  if (paddedContent.length < height) {
    paddedContent.addAll(List.generate(height - paddedContent.length, (_) => ' ' * width));
  } else if (paddedContent.length > height) {
    paddedContent = paddedContent.sublist(0, height);
  }
  return paddedContent;
}

List<String> padding({
  required List<String> child,
  required int height,
  required int width,
  int top = 0,
  int bottom = 0,
  int right = 0,
  int left = 0,
}) {
  List<String> paddedContent = [];

  // Add top padding
  for (int i = 0; i < top; i++) {
    paddedContent.add(' ' * width);
  }

  // Add left and right padding to each line of the child
  for (String line in child) {
    String paddedLine = ' ' * left + line.padRight(width - left - right) + ' ' * right;
    paddedContent.add(paddedLine);
  }

  // Add bottom padding
  for (int i = 0; i < bottom; i++) {
    paddedContent.add(' ' * width);
  }

  // Ensure the total height is respected
  if (paddedContent.length < height) {
    paddedContent.addAll(List.generate(height - paddedContent.length, (_) => ' ' * width));
  } else if (paddedContent.length > height) {
    paddedContent = paddedContent.sublist(0, height);
  }

  return paddedContent;
}

class Colors {
  static const String reset = '\x1B[0m';
  static const String black = '\x1B[30m';
  static const String red = '\x1B[31m';
  static const String green = '\x1B[32m';
  static const String yellow = '\x1B[33m';
  static const String blue = '\x1B[34m';
  static const String magenta = '\x1B[35m';
  static const String cyan = '\x1B[36m';
  static const String white = '\x1B[37m';
  static const String brightBlack = '\x1B[90m';
  static const String brightRed = '\x1B[91m';
  static const String brightGreen = '\x1B[92m';
  static const String brightYellow = '\x1B[93m';
  static const String brightBlue = '\x1B[94m';
  static const String brightMagenta = '\x1B[95m';
  static const String brightCyan = '\x1B[96m';
  static const String brightWhite = '\x1B[97m';
}

String text(String content, {String color = '', bool bold = false, bool underline = false}) {
  final buffer = StringBuffer();

  if (color.isNotEmpty) {
    buffer.write(color);
  }
  if (bold) {
    buffer.write('\x1B[1m');
  }
  if (underline) {
    buffer.write('\x1B[4m');
  }

  buffer.write(content);

  // Reset styles
  buffer.write('\x1B[0m');

  return buffer.toString();
}

List<String> row({required List<List<String>> children, required int height, required int width}) {
  List<String> rows = List.generate(height, (_) => '');

  for (int i = 0; i < height; i++) {
    for (int j = 0; j < children.length; j++) {
      final child = children[j];
      final childWidth = ((width - children.length + 1) / children.length).toInt();

      final content = child.length > i ? child[i] : '';
      final truncatedContent = content.trim().isNotEmpty && content.length > childWidth
          ? '${content.substring(0, childWidth - 1)}…'
          : content;
      rows[i] += truncatedContent.padRight(childWidth);

      if (j < children.length - 1) {
        rows[i] += '\u2502';
      }
    }
  }

  return rows;
}
