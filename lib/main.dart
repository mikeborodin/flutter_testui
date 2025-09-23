import 'dart:async';
import 'dart:io';

import 'package:testui3/app_state.dart';
import 'package:testui3/tests/test_event_mapper.dart';
import 'package:testui3/ui/draw.dart';
import 'package:args/args.dart';

import 'terminal/terminal.dart';
import 'tests/test_runner.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()..addOption('command', abbr: 'c', defaultsTo: 'dart test -r json');
  final argResults = parser.parse(arguments);
  final testCommand = argResults['command'] as String;

  final testRunner = TestRunner(testCommand);

  try {
    final terminal = Terminal()..setup();
    terminal.write('\x1B[?25l'); // Hide the cursor using escape sequence
    final state = AppState();

    final eventProcessor = TestEventMapper(state);

    final runnerSub = testRunner.stream.listen((event) {
      eventProcessor.process(event);
      draw(terminal, state);
    });

    testRunner.runAll();

    if (!stdout.supportsAnsiEscapes) {
      terminal.write('ANSI escaped codes are not supported');
    }

    final timer = Timer.periodic(Duration(milliseconds: 200), (_) {
      draw(terminal, state);
    });

    final sub = terminal.readKeys().listen((keyEvent) {
      if (keyEvent.character == 's') {
        testRunner.stopAll();
      } else if (keyEvent.character == 'r') {
        testRunner.runAll();
      } else if (keyEvent.character == 'q') {
        exitApp(terminal, null);
      } else if (keyEvent.character == 'e') {
        state.index = state.index + 1;
        state.statusLine += keyEvent.character ?? '';
        // console.write('hello');
        draw(terminal, state);
      } else if (keyEvent.character == 'u') {
        state.index = state.index - 1;
        state.statusLine += keyEvent.character ?? '';
        draw(terminal, state);
      }
      if (keyEvent.character == 'q') {
        exitApp(terminal, null);
      }
      if (keyEvent.character == 'r') {
        testRunner.runAll();
      }
      state.statusLine = keyEvent.toString();
    });

    await Future.any([ProcessSignal.sigint.watch().first, sub.asFuture(), runnerSub.asFuture()]);

    await sub.cancel();
    await runnerSub.cancel();
    timer.cancel();
    exitApp(terminal, null);
  } catch (err) {
    // console.showCursor();
    // exitApp(console, err.toString());
  }
}

void exitApp(Terminal terminal, String? errorMessage) {
  // console.;
  // console.rawMode = false;
  // console.resetCursorPosition();

  terminal.write('\x1B[?25h'); // Show the cursor using escape sequence
  if (errorMessage != null) {
    terminal.write(errorMessage);
    exit(1);
  } else {
    exit(0);
  }
}
