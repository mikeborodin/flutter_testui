import 'package:testui3/app_state.dart';
import 'package:testui3/terminal/terminal.dart';
import 'package:testui3/ui/icons.dart';

import 'colors.dart';
import 'widgets.dart';

void draw(Terminal t, AppState state) {
  t.clear();

  final lines = t.getWindowHeight() - 1;

  List<String> testList = [];

  int currentLine = 0;
  int visibleStart = 0; // This should be dynamically set based on user input or scroll position
  final width = (t.getWindowWidth()).toInt();

  for (final suite in state.tests.keys.skip(visibleStart)) {
    if (currentLine >= lines) break;
    testList.add('Suite: $suite');
    currentLine++;

    for (final test in state.tests[suite]!.keys.skip(visibleStart)) {
      if (currentLine >= lines) break;
      final testState = state.tests[suite]![test];
      bool selected() => state.index == currentLine;

      final fg = selected()
          ? FgColors.black
          : testState?.result == 'success'
          ? FgColors.green
          : testState?.result == 'running'
          ? FgColors.yellow
          : FgColors.red;

      final icon = testState?.result == 'success'
          ? Icons.check
          : testState?.result == 'running'
          ? Icons.inProgress
          : Icons.error;

      final line = ' $icon ${testState?.name}';

      final bg = selected() ? BgColors.yellow : '';

      testList.add(colored(line.padRight((width / 3).toInt() - 2, ' '), fg: fg, bg: bg));

      currentLine++;
    }
  }

  t.write(
    [
      row(
        children: [
          testList,
          [colored(state.index.toString(), fg: FgColors.red)],
          [
            ...wrapped(
              "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).",
              width: (width / 3).toInt()-2,
            ),
          ],
        ],
        width: width,
        height: t.getWindowHeight() - 1,
      ),
      [colored(state.statusLine.padRight(width), bg: BgColors.brightBlue, fg: FgColors.black)],
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
