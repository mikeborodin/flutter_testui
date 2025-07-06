import 'dart:async';
import 'dart:io';

import 'package:dart_console/dart_console.dart';
import 'package:pixel_prompt/pixel_prompt.dart';

final console = Console();

void main() async {
  try {
    console.rawMode = true;

    final Rect rect = Rect(x: 0, y: 0, width: 0, height: 0);
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

    final timer = Timer.periodic(Duration(milliseconds: 200), (_) {
      draw();
    });

    final sub = stdin.listen((event) {
      state = event.toString();

        // AI!
    });
  } catch (e) {
    crash(e.toString());
  }
}

void refreshScreen() {
  console.clearScreen();
  console.write(DateTime.timestamp().toString());
  Future.delayed(Duration(milliseconds: 16));
  console.resetCursorPosition();
}

void crash(String message) {
  console.clearScreen();
  console.resetCursorPosition();
  console.rawMode = false;
  console.write(message);
  exit(1);
}
