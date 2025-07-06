import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:testui3/test_event_parser.dart';

class TestRunner {
  final String testCommand;

  TestRunner(this.testCommand);
  final StreamController<dynamic> _controller = StreamController<dynamic>();
  Process? _process;

  Stream<dynamic> get stream => _controller.stream;

  Future<void> runAll() async {
    final parser = TestEventParser();
    final commandParts = testCommand.split(' ');
    _process = await Process.start(commandParts[0], commandParts.sublist(1));

    _process?.stdout.transform(utf8.decoder).transform(LineSplitter()).listen((line) {
      try {
        final event = parser.parseEvent(line);
        _controller.add(event);
      } catch (e) {
        print('Error parsing event: $e');
        exit(2);
      }
    });
  }

  void stopAll() {
    _process?.kill();
  }
}
