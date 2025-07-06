import 'package:testui3/app_state.dart';
import 'package:testui3/test_events.dart';
import 'package:testui3/test_state.dart';

class TestEventMapper {
  final AppState state;

  TestEventMapper(this.state);

  void process(dynamic event) {
    if (event is TestStartEvent) {
      state.updateTestState(
        event.suiteID.toString(),
        event.name,
        TestState(name: event.name, skipped: false, result: 'running'),
      );
    } else if (event is TestDoneEvent) {
      // Update the test state based on the event
    }
    // Add more event processing logic as needed
  }
}
