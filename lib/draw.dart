import 'package:dart_console/dart_console.dart';
import 'package:testui3/app_state.dart';

void draw(Console console, AppState state) {
  console.clearScreen();
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
  for (final suite in state.tests.keys) {
    if (currentLine >= lines) break;
    console.writeLine('Suite: $suite');
    currentLine++;
    for (final test in state.tests[suite]!.keys) {
      if (currentLine >= lines) break;
      final testState = state.tests[suite]![test];
      final colorCode = testState?.result == 'success'
          ? '\x1B[32m' // Green for success
          : testState?.result == 'running'
          ? '\x1B[33m' // Yellow for running
          : '\x1B[31m'; // Red for failure

      console.writeLine('$colorCode> ${testState?.name}  | ${testState?.result}\x1B[0m');
      currentLine++;
    }
  }
}

void drawDivider(Console console) {
  console.writeLine('\u2500' * console.windowWidth); // Unicode horizontal line
}

void drawBottomPane(Console console, AppState state, int lines) {
  final lastSuite = state.tests.keys.lastOrNull;
  if (lastSuite == null) {
    console.writeLine('no details yet');
    return;
  }

  final lastTest = state.tests[lastSuite]!.keys.last;
  final testState = state.tests[lastSuite]![lastTest];

  console.writeLine('Details for: ${testState?.name}');
  console.writeLine('Result: ${testState?.result}');
  console.writeLine('Skipped: ${testState?.skipped}');
}
