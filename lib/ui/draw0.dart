import 'dart:io';

import 'package:testui3/app_state.dart';
import 'package:testui3/terminal/terminal.dart';

void draw(Terminal t, AppState state) {
  stdout.writeln('status; ${state.statusLine}');

  t.clear();
  final totalLines = t.getWindowHeight();
  final topPaneLines = (totalLines * 0.6).toInt();
  final bottomPaneLines = totalLines - topPaneLines - 1; // -1 for the divider

  drawTopPane(t, state, topPaneLines);
  drawDivider(t);
  drawBottomPane(t, state, bottomPaneLines);
}

void drawTopPane(Terminal t, AppState state, int lines) {
  int currentLine = 0;
  int visibleStart = 0; // This should be dynamically set based on user input or scroll position

  for (final suite in state.tests.keys.skip(visibleStart)) {
    if (currentLine >= lines) break;
    t.write('Suite: $suite\n');
    currentLine++;

    for (final test in state.tests[suite]!.keys.skip(visibleStart)) {
      if (currentLine >= lines) break;
      final testState = state.tests[suite]![test];
      final colorCode = testState?.result == 'success'
          ? '\x1B[32m' // Green for success
          : testState?.result == 'running'
          ? '\x1B[33m' // Yellow for running
          : '\x1B[31m'; // Red for failure

      final line =
          '$colorCode ${state.index == currentLine ? '>' : ' '} ${testState?.name}  | ${testState?.result}\x1B[0m';
      final cappedLine = line.length >= t.getWindowWidth()
          ? line.substring(0, t.getWindowWidth())
          : line;
      t.writeLine(cappedLine);

      currentLine++;
    }
  }
}

void drawDivider(Terminal t) {
  t.write('\u2500' * t.getWindowWidth() + '\n'); // Unicode horizontal line
}

void drawBottomPane(Terminal t, AppState state, int lines) {
  final lastSuite = state.tests.keys.isNotEmpty ? state.tests.keys.last : null;
  if (lastSuite == null) {
    for (int i = 0; i < lines; i++) {
      t.write(' ' * t.getWindowWidth());
      // Console.class = Coordinate(console.cursorPosition!.row + 1, 0);
    }
    // console.write('Select please\n');
    return;
  }

  // final lastTest = state.tests[lastSuite]!.keys.last;
  // final testState = state.tests[lastSuite]![lastTest];
}
