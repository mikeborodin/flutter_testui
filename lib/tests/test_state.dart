import 'package:testui3/tests/test_events.dart';

class NodeState {
  final String name;
  TestResult? result;
  bool isRunning;
  bool skipped;

  NodeState({
    required this.name,
    required this.skipped,
    required this.result,
    this.isRunning = false,
  });
}
