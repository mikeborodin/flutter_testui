import 'package:testui3/tests/test_events.dart';

class TestDetails {
  final String name;
  final TestResult? result;
  final bool isRunning;
  final bool skipped;

  TestDetails({
    required this.name,
    required this.skipped,
    required this.result,
    this.isRunning = false,
  });
}
