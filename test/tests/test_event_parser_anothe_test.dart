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

    test('should parse TestStartEvent', () {
      const jsonLine =
          '{"test":{"id":1,"name":"loading /Users/mike/personal_projects/testui/test/testui_s_test.dart","suiteID":0,"groupIDs":[],"metadata":{"skip":false,"skipReason":null},"line":null,"column":null,"url":null},"type":"testStart","time":10}';
      final event = parser.parseEvent(jsonLine) as TestStartEvent;

      expect(event.id, 1);
      expect(event.name, 'loading /Users/mike/personal_projects/testui/test/testui_s_test.dart');
      expect(event.suiteID, 0);
      expect(event.groupIDs, isEmpty);
      expect(event.metadata.skip, false);
      expect(event.metadata.skipReason, isNull);
      expect(event.line, isNull);
      expect(event.column, isNull);
      expect(event.url, isNull);
      expect(event.type, 'testStart');
      expect(event.time, 10);
    });

    test('should parse AllSuitesEvent', () {
      const jsonLine = '{"count":2,"time":13,"type":"allSuites"}';
      final event = parser.parseEvent(jsonLine) as AllSuitesEvent;

      expect(event.count, 2);
      expect(event.type, 'allSuites');
      expect(event.time, 13);
    });

    test('should parse TestDoneEvent', () {
      const jsonLine =
          '{"testID":1,"result":"success","skipped":false,"hidden":true,"type":"testDone","time":573}';
      final event = parser.parseEvent(jsonLine) as TestDoneEvent;

      expect(event.testID, 1);
      expect(event.result, 'success');
      expect(event.skipped, false);
      expect(event.hidden, true);
      expect(event.type, 'testDone');
      expect(event.time, 573);
    });

    test('should parse GroupEvent', () {
      const jsonLine =
          '{"group":{"id":4,"suiteID":0,"parentID":null,"name":"","metadata":{"skip":false,"skipReason":null},"testCount":1,"line":null,"column":null,"url":null},"type":"group","time":574}';
      final event = parser.parseEvent(jsonLine) as GroupEvent;

      expect(event.id, 4);
      expect(event.suiteID, 0);
      expect(event.parentID, isNull);
      expect(event.name, '');
      expect(event.metadata.skip, false);
      expect(event.metadata.skipReason, isNull);
      expect(event.testCount, 1);
      expect(event.line, isNull);
      expect(event.column, isNull);
      expect(event.url, isNull);
      expect(event.type, 'group');
      expect(event.time, 574);
    });

    test('should parse DoneEvent', () {
      const jsonLine = '{"success":true,"type":"done","time":627}';
      final event = parser.parseEvent(jsonLine) as DoneEvent;

      expect(event.success, true);
      expect(event.type, 'done');
      expect(event.time, 627);
    });
  });
}
