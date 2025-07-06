import 'dart:io';

import 'package:dart_console/dart_console.dart';
import 'package:testui3/app_state.dart';

void draw(Console console, AppState state) {
  // console.clearScreen();
  console.resetCursorPosition();

  final totalLines = console.windowHeight;
  final topPaneLines = (totalLines * 0.6).toInt();
  final bottomPaneLines = totalLines - topPaneLines - 1; // -1 for the divider

  drawTopPane(console, state, topPaneLines);
  drawDivider(console);
  drawBottomPane(console, state, bottomPaneLines);
}

void drawTopPane(Console console, AppState state, int lines) {
  int currentLine = 0;
  int visibleStart = 0; // This should be dynamically set based on user input or scroll position

  for (final suite in state.tests.keys.skip(visibleStart)) {
    if (currentLine >= lines) break;
    console.writeAligned('Suite: $suite', console.windowWidth);
    currentLine++;

    for (final test in state.tests[suite]!.keys.skip(visibleStart)) {
      if (currentLine >= lines) break;
      final testState = state.tests[suite]![test];
      final colorCode = testState?.result == 'success'
          ? '\x1B[32m' // Green for success
          : testState?.result == 'running'
          ? '\x1B[33m' // Yellow for running
          : '\x1B[31m'; // Red for failure

      console.writeAligned(
        '$colorCode> ${testState?.name}  | ${testState?.result}\x1B[0m',
        console.windowWidth,
      );
      if (console.cursorPosition != null) {
        console.cursorPosition = Coordinate(console.cursorPosition!.row, 1);
      }

      currentLine++;
    }
  }
}

void drawDivider(Console console) {
  console.writeAligned(
    '\u2500' * console.windowWidth,
    console.windowWidth,
  ); // Unicode horizontal line
}

void drawBottomPane(Console console, AppState state, int lines) {
  final lastSuite = state.tests.keys.lastOrNull;
  if (lastSuite == null) {
    for (int i = 0; i < lines; i++) {
      stdout.writeln('');
    }
    stdout.writeln('Select please');
    if (console.cursorPosition != null) {
      console.cursorPosition = Coordinate(console.cursorPosition!.row, 1);
    }
    return;
  }

  final lastTest = state.tests[lastSuite]!.keys.last;
  final testState = state.tests[lastSuite]![lastTest];

  for (int i = 0; i < lines; i++) {
    stdout.writeln('');
  }
  stdout.writeln('Details for: ${testState?.name}');
  if (console.cursorPosition != null) {
    console.cursorPosition = Coordinate(console.cursorPosition!.row, 1);
  }
  stdout.writeln('Result: ${testState?.result}');
  if (console.cursorPosition != null) {
    console.cursorPosition = Coordinate(console.cursorPosition!.row, 1);
  }
  stdout.writeln('Skipped: ${testState?.skipped}');
  if (console.cursorPosition != null) {
    console.cursorPosition = Coordinate(console.cursorPosition!.row, 1);
  }
}
