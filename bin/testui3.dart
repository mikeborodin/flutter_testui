import 'package:dart_console/dart_console.dart';
import 'package:pixel_prompt/pixel_prompt.dart';

void main() async {
  final console = Console();
  console.rawMode = true;

  final Rect rect = Rect(x: 0, y: 0, width: 0, height: 0);

  while (true) {
    console.clearScreen();
    console.write(DateTime.timestamp().toString());
    console.cursorPosition = Coordinate(0, 0);
    Future.delayed(Duration(milliseconds: 16));
  }
}
