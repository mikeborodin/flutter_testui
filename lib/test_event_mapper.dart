import 'package:testui3/app_state.dart';
import 'package:testui3/test_events.dart';
import 'package:testui3/test_state.dart';

class TestEventMapper {
  final AppState state;
  final Map<int, String> suiteIdToFilePath = {};
  final Map<int, String> testIdToTestName = {};

  TestEventMapper(this.state);

  void process(dynamic event) {
    if (event is TestStartEvent) {
      testIdToTestName[event.id] = event.name;

      state.updateTestState(
        suiteIdToFilePath[event.suiteID] ?? 'unknown',
        event.name,
        TestState(name: event.name, skipped: false, result: 'running'),
      );
    } else if (event is TestDoneEvent) {
      final testName = testIdToTestName[event.testID] ?? 'unknown';
      state.updateTestState(
        suiteIdToFilePath[event.testID] ?? 'unknown',
        testName,
        TestState(name: testName, skipped: event.skipped, result: event.result),
      );
    } else if (event is SuiteEvent) {
      suiteIdToFilePath[event.id] = event.path;
      state.statusLine = 'Running suite: ${event.path}';
    } else if (event is GroupEvent) {
      // Handle group events if needed
    } else if (event is DoneEvent) {
      state.statusLine = event.success ? 'All tests passed!' : 'Some tests failed!';
    }
  }
}
