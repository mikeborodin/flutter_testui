import 'package:test/test.dart';
import 'package:testui3/tests/test_event_parser.dart';
import 'package:testui3/tests/test_events.dart';

void main() {
  group('TestEventParser', () {
    final parser = TestEventParser();

    test('should parse StartEvent', () {
      const jsonLine =
          '{"protocolVersion":"0.1.1","runnerVersion":"1.25.4","pid":89144,"type":"start","time":0}';
      final event = parser.parseEvent(jsonLine) as StartEvent;

      expect(event.protocolVersion, '0.1.1');
      expect(event.runnerVersion, '1.25.4');
      expect(event.pid, 89144);
      expect(event.type, 'start');
      expect(event.time, 0);
    });

    test('should parse SuiteEvent', () {
      const jsonLine =
          '{"suite":{"id":0,"platform":"vm","path":"/Users/mike/personal_projects/testui/test/testui_s_test.dart"},"type":"suite","time":0}';
      final event = parser.parseEvent(jsonLine) as SuiteEvent;

      expect(event.id, 0);
      expect(event.platform, 'vm');
      expect(event.path, '/Users/mike/personal_projects/testui/test/testui_s_test.dart');
      expect(event.type, 'suite');
      expect(event.time, 0);
    });
  });
}
