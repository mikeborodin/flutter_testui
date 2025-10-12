import 'package:testui3/app_state.dart';
import 'package:testui3/tests/test_events.dart';

class TestEventProcessor {
  final AppState state;

  TestEventProcessor({required this.state});

  final List<dynamic> history = [];

  void process(dynamic event) {
    if (event is StartEvent) {
      history.clear();
      state.logs.clear();

      state.statusLine =
          'start event; runner ${event.runnerVersion} protocol: ${event.protocolVersion}';
      state.tree = TestTreeData();
    }
    if (event is GroupEvent) {
      state.statusLine = 'group event;';
    }
    if (event is TestStartEvent) {
      state.statusLine = 'test start';
    }
    if (event is TestDoneEvent) {
      state.statusLine = 'test done';
    }
    if (event is SuiteEvent) {
      state.statusLine = 'suite event ${event.path}';
    }
    if (event is AllSuitesEvent) {
      state.statusLine = 'all suites';
    }
    if (event is DoneEvent) {
      state.statusLine = 'done! ${event.time} ms';
    }


    try {
      state.time = Duration(milliseconds: event.time);
    } catch (e) {
      state.logs.add('can not get .time of $event');
    }

    state.logs.add('event $event');
    history.add(event);
  }
}
