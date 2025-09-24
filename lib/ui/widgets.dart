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

List<String> wrapped(String value, {required int width}) {
  List<String> lines = [];
  StringBuffer buffer = StringBuffer();
  int currentWidth = 0;

  for (final word in value.split(' ')) {
    if (currentWidth + word.length > width) {
      lines.add(buffer.toString().trim());
      buffer.clear();
      currentWidth = 0;
    }
    buffer.write('$word ');
    currentWidth += word.length + 1;
  }

  if (buffer.isNotEmpty) {
    lines.add(buffer.toString().trim());
  }

  return lines;
}

String colored(
  String content, {
  String fg = '',
  String bg = '',
  bool bold = false,
  bool underline = false,
}) {
  final buffer = StringBuffer();

  if (bg.isNotEmpty) {
    buffer.write(bg); // Correctly set background color
  }
  if (fg.isNotEmpty) {
    buffer.write(fg);
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

String truncateWithoutRemovingEscapeSequences(String input, int maxLength) {
  final buffer = StringBuffer();
  int visibleLength = 0;

  final regex = RegExp(r'\x1B\[[0-9;]*m|\x1B\[0m');
  final matches = regex.allMatches(input);
  int lastMatchEnd = 0;

  for (final match in matches) {
    if (visibleLength >= maxLength) break;

    final segment = input.substring(lastMatchEnd, match.start);
    final segmentLength = segment.length;

    if (visibleLength + segmentLength > maxLength) {
      buffer.write(segment.substring(0, maxLength - visibleLength));
      visibleLength = maxLength;
    } else {
      buffer.write(segment);
      visibleLength += segmentLength;
    }

    buffer.write(match.group(0));
    lastMatchEnd = match.end;
  }

  if (visibleLength < maxLength) {
    buffer.write(
      input.substring(lastMatchEnd, input.length).substring(0, maxLength - visibleLength),
    );
  }

  return buffer.toString();
}

List<String> row({required List<List<String>> children, required int height, required int width}) {
  List<String> rows = List.generate(height, (_) => '');

  for (int i = 0; i < height; i++) {
    for (int j = 0; j < children.length; j++) {
      final child = children[j];
      final childWidth = ((width) / children.length).toInt() - children.length + 1;

      final content = child.length > i ? child[i] : '';
      final visibleContentLength = content
          .replaceAll(RegExp(r'\x1B\[[0-9;]*m|\x1B\[0m'), '')
          .length;

      final truncatedContent = visibleContentLength > childWidth
          ? '${truncateWithoutRemovingEscapeSequences(content, childWidth - 1)}…'
          : content;

      rows[i] += truncatedContent.padRight(
        childWidth - visibleContentLength + truncatedContent.length,
      );

      if (j < children.length - 1) {
        rows[i] += '\u2502';
      }
    }
  }

  return rows;
}
