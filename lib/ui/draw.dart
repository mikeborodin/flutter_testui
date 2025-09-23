import 'package:testui3/app_state.dart';
import 'package:testui3/terminal/terminal.dart';

import 'widgets.dart';

void draw(Terminal t, AppState state) {
  t.clear();

  final lines = t.getWindowHeight() - 1;

  List<String> screen = [];

  int currentLine = 0;
  int visibleStart = 0; // This should be dynamically set based on user input or scroll position

  for (final suite in state.tests.keys.skip(visibleStart)) {
    if (currentLine >= lines) break;
    screen.add('Suite: $suite\n');
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

      screen.add(line);

      currentLine++;
    }
  }

  final width = (t.getWindowWidth()).toInt();

  t.write(
    [
      // ...screen.map((s) => s.length <= width ? s : s.substring(0, width + 1)),
      // ...divider(t),
      row(
        width: width,
        height: 6,
        children: [
          // verticalPadding(child: ['Flutter Test UI'], height: 4, width: width),
          [text('Flutter TEST UI', color: Colors.cyan, bold: true)],
          ['Details'],
        ],
      ),

      divider(width: width),
      row(
        children: [
          [
            '// ...screen.map((s) => s.length <= width ? s : s.substring(0, width + 1)),',
            '// ...screen.map((s) => s.length <= width ? s : s.substring(0, width + 1)),',
            '// ...screen.map((s) => s.length <= width ? s : s.substring(0, width + 1)),',
            '// ...screen.map((s) => s.length <= width ? s : s.substring(0, width + 1)),',
          ],
          [
            '// ...screen.map((s) => s.length <= width ? s : s.substring(0, width + 1)),',
            '// ...screen.map((s) => s.length <= width ? s : s.substring(0, width + 1)),',
            '// ...screen.map((s) => s.length <= width ? s : s.substring(0, width + 1)),',
            '// ...screen.map((s) => s.length <= width ? s : s.substring(0, width + 1)),',
          ],
          ['b'],
        ],
        width: width,
        height: 3,
      ),
      row(
        width: width,
        height: 6,
        children: [
          // verticalPadding(child: ['Flutter Test UI'], height: 4, width: width),
          ['List'],
          ['Details'],
        ],
      ),
    ].map((l) => l.join('\n')).join('\n'),
  );
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

List<String> divider({required width}) {
  return ['\u2500' * width];
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
