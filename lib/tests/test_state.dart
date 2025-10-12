import 'package:testui3/tests/test_events.dart';

class TestState {
  final String name;
  final String result0;
  final TestStatus result;
  final bool skipped;

  TestState({
    required this.name,
    required this.result,
    required this.skipped,
    required this.result0,
  });
}
