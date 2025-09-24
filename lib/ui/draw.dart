import 'package:testui3/app_state.dart';
import 'package:testui3/terminal/terminal.dart';

import 'widgets.dart';

void draw(Terminal t, AppState state) {
  t.clear();

  final lines = t.getWindowHeight() - 1;

  List<String> testList = [];

  int currentLine = 0;
  int visibleStart = 0; // This should be dynamically set based on user input or scroll position

  for (final suite in state.tests.keys.skip(visibleStart)) {
    if (currentLine >= lines) break;
    testList.add('Suite: $suite');
    currentLine++;

    for (final test in state.tests[suite]!.keys.skip(visibleStart)) {
      if (currentLine >= lines) break;
      final testState = state.tests[suite]![test];
      final fg = testState?.result == 'success'
          ? Colors.green
          : testState?.result == 'running'
          ? Colors.yellow
          : Colors.red;

      final line =
          '${state.index == currentLine ? '>' : ' '}${testState?.name}  | ${testState?.result}';

      final bg = state.index == currentLine ? Colors.yellow : '';

      testList.add(colored(line, fg: fg, bg: bg));

      currentLine++;
    }
  }

  final width = (t.getWindowWidth()).toInt();

  t.write(
    [
      row(
        children: [
          testList,
          [colored(state.index.toString(), fg: Colors.red)],
          ['hello'],
        ],
        width: width,
        height: t.getWindowHeight(),
      ),
    ].map((l) => l.join('\n')).join('\n'),
  );
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
