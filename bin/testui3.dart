import 'dart:async';
import 'dart:io';

import 'package:dart_console/dart_console.dart';
import 'package:testui3/src/key_event.dart';

void main() async {
  final console = Console();
  try {
    console.rawMode = true;

    // Get and store initial window size
    // final _rect = Rect(x: 0, y: 0, width: console.windowWidth, height: console.windowHeight);
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

    // Setup periodic screen refresh
    final timer = Timer.periodic(Duration(milliseconds: 100), (_) {
      draw();
    });

    // Listen for keyboard input
    final sub = stdin.listen((event) {
      final keyEvent = KeyEvent.fromBytes(event);

      state = keyEvent.toString();
      draw();

      // Handle 'q' key press
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
