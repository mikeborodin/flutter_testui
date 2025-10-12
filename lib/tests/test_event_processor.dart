import 'package:testui3/app_state.dart';
import 'package:testui3/tests/test_events.dart';

class TestEventProcessor {
  final AppState _state;

  TestEventProcessor({required AppState state}) : _state = state;

  void process(dynamic event) {
    if (event is StartEvent) {
      _state.statusLine =
          'start event; runner ${event.runnerVersion} protocol: ${event.protocolVersion}';
    }
    if (event is GroupEvent) {
      _state.statusLine = 'group event;';
    }
    if (event is TestStartEvent) {
      _state.statusLine = 'test start';
    }
    if (event is TestDoneEvent) {
      _state.statusLine = 'test done';
    }
    if (event is SuiteEvent) {
      _state.statusLine = 'suite event ${event.path}';
    }
    if (event is AllSuitesEvent) {
      _state.statusLine = 'all suites';
    }
    if (event is DoneEvent) {
      _state.statusLine = 'done! ${event.time} ms';
    }
  }
}
