import 'dart:async';
import 'dart:io';

import 'package:dart_console/dart_console.dart';
import 'package:testui3/app_state.dart';
import 'package:testui3/key_event.dart';
import 'package:testui3/test_runner.dart';

void main() async {
  final console = Console();
  final testRunner = TestRunner();

  try {
    console.rawMode = true;

    final state = AppState();

    void draw() {
      console.clearScreen();
      console.write(DateTime.timestamp().toString());
      for (final file in state.tests.keys) {
        console.write(file);
        console.write(' ');
        console.write(state.tests[file] ?? '<no path>');
        console.write('\n');

        for (final test in (state.tests[file]?.keys ?? [])) {
          console.write('* ');
          console.write(state.tests[file]?[test] ?? '<no state>');
          console.write('\n');
        }
      }
      console.resetCursorPosition();
    }

    final runnerSub = testRunner.stream.listen((event) {
      draw();
    });

    testRunner.runAll();

    if (!stdout.supportsAnsiEscapes) {
      console.write('ANSI escaped codes are not supported');
    }

    final timer = Timer.periodic(Duration(milliseconds: 100), (_) {
      draw();
    });

    final sub = stdin.listen((event) {
      final keyEvent = KeyEvent.fromBytes(event);

      state.statusLine = 'pressed $keyEvent';

      draw();

      if (keyEvent.type == KeyType.character && keyEvent.character == 's') {
        testRunner.stopAll();
      } else if (keyEvent.type == KeyType.character && keyEvent.character == 'r') {
        testRunner.runAll();
      } else if (keyEvent.type == KeyType.character && keyEvent.character == 'q') {
        exitApp(console, null);
      }
    });

    await Future.any([ProcessSignal.sigint.watch().first, sub.asFuture(), runnerSub.asFuture()]);

    await sub.cancel();
    await runnerSub.cancel();
    timer.cancel();
    exitApp(console, null);
  } catch (err) {
    exitApp(console, err.toString());
  }
}

void exitApp(Console console, String? errorMessage) {
  console.clearScreen();
  console.rawMode = false;
  console.resetCursorPosition();

  if (errorMessage != null) {
    console.write(errorMessage);
    exit(1);
  } else {
    exit(0);
  }
}
