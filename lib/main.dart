import 'package:args/args.dart';
import 'package:hotreloader/hotreloader.dart';
import 'package:nocterm/nocterm.dart';
import 'package:testui3/tests/test_runner.dart';

import 'app.dart';

void main(List<String> args) async {
  HotReloader? reloader;

  if (bool.fromEnvironment('hot')) {
    reloader = await HotReloader.create();
  }

  final parser = ArgParser()..addOption('command', abbr: 'c', defaultsTo: 'dart test -r json');
  final argResults = parser.parse(args);
  final testCommand = argResults['command'] as String;

  await runApp(TestUiApp(runner: TestRunner(testCommand)));

  reloader?.stop();
}
