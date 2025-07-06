import 'dart:async';
import 'dart:io';

import 'package:dart_console/dart_console.dart';
import 'package:testui3/app_state.dart';
import 'package:testui3/key_event.dart';
import 'package:testui3/test_runner.dart';
import 'package:args/args.dart';
import 'package:testui3/test_event_mapper.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()..addOption('command', abbr: 'c', defaultsTo: 'dart test -r json');
  final argResults = parser.parse(arguments);
  final testCommand = argResults['command'] as String;

  final console = Console();
  final testRunner = TestRunner(testCommand);

  try {
    console.rawMode = true;

    final state = AppState();

    void draw() {
      console.clearScreen();
      console.writeLine(state.statusLine);

      // console.write(DateTime.timestamp().toString());
      for (final suite in state.tests.keys) {
        console.writeLine('Suite:$suite');

        for (final test in (state.tests[suite]?.keys ?? [])) {
          final testState = state.tests[suite]?[test];
          final colorCode = testState?.result == 'success'
              ? '\x1B[32m' // Green for success
              : testState?.result == 'running'
              ? '\x1B[33m' // Yellow for running
              : '\x1B[31m'; // Red for failure

          console.writeLine('$colorCode> ${testState?.name}  | ${testState?.result}\x1B[0m');
        }
      }
      console.resetCursorPosition();
    }

    final eventProcessor = TestEventMapper(state);

    final runnerSub = testRunner.stream.listen((event) {
      eventProcessor.process(event);
      draw();
    });

    testRunner.runAll();

    if (!stdout.supportsAnsiEscapes) {
      console.write('ANSI escaped codes are not supported');
    }

    final timer = Timer.periodic(Duration(milliseconds: 20), (_) {
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
