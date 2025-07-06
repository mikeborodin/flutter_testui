import 'package:testui3/app_state.dart';
import 'package:testui3/test_events.dart';
import 'package:testui3/test_state.dart';

class TestEventMapper {
  final AppState state;

  TestEventMapper(this.state);

  void process(dynamic event) {
    if (event is TestStartEvent) {
      state.updateTestState(
        '0',
        event.id.toString(),
        TestState(name: event.id.toString(), skipped: false, result: 'running'),
      );
    } else if (event is TestDoneEvent) {
      state.updateTestState(
        '0',
        event.testID.toString(),
        TestState(name: event.testID.toString(), skipped: event.skipped, result: event.result),
      );
    } else if (event is SuiteEvent) {
      state.statusLine = 'Running suite: ${event.path}';
    } else if (event is GroupEvent) {
      // Handle group events if needed
    } else if (event is DoneEvent) {
      state.statusLine = event.success ? 'All tests passed!' : 'Some tests failed!';
    }
  }
}
