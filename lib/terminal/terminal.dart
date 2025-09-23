import 'dart:io';

import 'package:consola/consola.dart';

import 'key_event.dart';

class Terminal {
  void setup() {
    stdin.echoMode = false;
    stdin.lineMode = false;
  }

  void clear() {
    Console.clearScreen();
  }

  void write(String message) {
    Console.write(message);
  }

  void writeLine(String message) {
    Console.writeLine(message);
  }

  Stream<KeyEvent> readKeys() async* {
    List<int> escapeSequence = [];

    await for (var codeUnit in stdin.expand((x) => x)) {
      if (codeUnit == 0x1b) {
        escapeSequence.add(codeUnit);
        continue;
      }

      if (escapeSequence.isNotEmpty) {
        escapeSequence.add(codeUnit);
        if (escapeSequence.length == 2 && escapeSequence[1] == 0x5b) {
          continue;
        } else if (escapeSequence.length == 2) {
          final key = KeyEvent(KeyType.ctrl, String.fromCharCode(escapeSequence[1]));
          yield key;
          escapeSequence.clear();
        } else if (escapeSequence.length == 3) {
          final key = KeyEvent(KeyType.character, String.fromCharCode(escapeSequence[2]));
          yield key;
          escapeSequence.clear();
        } else {
          escapeSequence.clear();
        }
      } else {
        yield KeyEvent(KeyType.character, String.fromCharCode(codeUnit));
      }
    }
  }

  int getWindowHeight() => Console.getWindowHeight();
  int getWindowWidth() => Console.getWindowWidth();
}
