import 'package:testui3/tests/test_events.dart';

class NodeState {
  final String name;
  final TestResult? result;
  final bool isRunning;
  final bool skipped;

  NodeState({
    required this.name,
    required this.skipped,
    required this.result,
    this.isRunning = false,
  });
}
