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
  int visibleStart = 0; // This should be dynamically set based on user input or scroll position

  for (final suite in state.tests.keys.skip(visibleStart)) {
    if (currentLine >= lines) break;
    console.write('Suite: $suite\n');
    currentLine++;

    for (final test in state.tests[suite]!.keys.skip(visibleStart)) {
      if (currentLine >= lines) break;
      final testState = state.tests[suite]![test];
      final colorCode = testState?.result == 'success'
          ? '\x1B[32m' // Green for success
          : testState?.result == 'running'
          ? '\x1B[33m' // Yellow for running
          : '\x1B[31m'; // Red for failure

      console.write('$colorCode> ${testState?.name}  | ${testState?.result}\x1B[0m\n');
      currentLine++;
    }
  }
}

void drawDivider(Console console) {
  console.write('\u2500' * console.windowWidth + '\n'); // Unicode horizontal line
}

void drawBottomPane(Console console, AppState state, int lines) {
  final lastSuite = state.tests.keys.isNotEmpty ? state.tests.keys.last : null;
  if (lastSuite == null) {
    for (int i = 0; i < lines; i++) {
      console.write(' ' * console.windowWidth);
      console.cursorPosition = Coordinate(console.cursorPosition!.row + 1, 0);
    }
    console.write('Select please\n');
    return;
  }

  final lastTest = state.tests[lastSuite]!.keys.last;
  final testState = state.tests[lastSuite]![lastTest];

  for (int i = 0; i < lines; i++) {
    console.writeLine(' ');
  }
  console.write('Details for: ${testState?.name}\n');
  console.write('Result: ${testState?.result}\n');
  console.write('Skipped: ${testState?.skipped}\n');
}
