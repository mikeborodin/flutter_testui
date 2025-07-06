import 'dart:async';
import 'dart:io';

import 'package:dart_console/dart_console.dart';
import 'package:testui3/key_event.dart';

void main() async {
  final console = Console();
  try {
    console.rawMode = true;

    if (!stdout.supportsAnsiEscapes) {
      console.write('ANSI escaped codes are not supported');
    }

    String state = '';
    void draw() {
      console.clearScreen();
      console.write(DateTime.timestamp().toString());
      console.write(state);
      console.resetCursorPosition();
    }

    final timer = Timer.periodic(Duration(milliseconds: 100), (_) {
      draw();
    });

    final sub = stdin.listen((event) {
      final keyEvent = KeyEvent.fromBytes(event);

      state = keyEvent.toString();
      draw();

      if (keyEvent.type == KeyType.character && keyEvent.character == 'q') {
        exitApp(console, null);
      }
    });

    await Future.any([ProcessSignal.sigint.watch().first, sub.asFuture<void>()]);

    await sub.cancel();
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
