import 'dart:convert';
import 'test_events.dart';

class TestEventParser {
  dynamic parseEvent(String jsonLine) {
    final Map<String, dynamic> jsonData = json.decode(jsonLine);

    switch (jsonData['type']) {
      case 'start':
        return _parseStartEvent(jsonData);
      case 'suite':
        return _parseSuiteEvent(jsonData);
      case 'testStart':
        return _parseTestStartEvent(jsonData);
      case 'allSuites':
        return _parseAllSuitesEvent(jsonData);
      case 'testDone':
        return _parseTestDoneEvent(jsonData);
      case 'group':
        return _parseGroupEvent(jsonData);
      case 'done':
        return _parseDoneEvent(jsonData);
      default:
        throw Exception('Unknown event type: ${jsonData['type']}');
    }
  }

  StartEvent _parseStartEvent(Map<String, dynamic> jsonData) {
    return StartEvent(
      protocolVersion: jsonData['protocolVersion'],
      runnerVersion: jsonData['runnerVersion'],
      pid: jsonData['pid'],
      type: jsonData['type'],
      time: jsonData['time'],
    );
  }

  SuiteEvent _parseSuiteEvent(Map<String, dynamic> jsonData) {
    return SuiteEvent(
      id: jsonData['suite']['id'],
      platform: jsonData['suite']['platform'],
      path: jsonData['suite']['path'],
      type: jsonData['type'],
      time: jsonData['time'],
    );
  }

  TestStartEvent _parseTestStartEvent(Map<String, dynamic> jsonData) {
    return TestStartEvent(
      id: jsonData['test']['id'],
      name: jsonData['test']['name'],
      suiteID: jsonData['test']['suiteID'],
      groupIDs: List<int>.from(jsonData['test']['groupIDs']),
      metadata: Metadata(
        skip: jsonData['test']['metadata']['skip'],
        skipReason: jsonData['test']['metadata']['skipReason'],
      ),
      line: jsonData['test']['line'],
      column: jsonData['test']['column'],
      url: jsonData['test']['url'],
      type: jsonData['type'],
      time: jsonData['time'],
    );
  }

  AllSuitesEvent _parseAllSuitesEvent(Map<String, dynamic> jsonData) {
    return AllSuitesEvent(count: jsonData['count'], type: jsonData['type'], time: jsonData['time']);
  }

  TestDoneEvent _parseTestDoneEvent(Map<String, dynamic> jsonData) {
    return TestDoneEvent(
      testID: jsonData['testID'],
      result: jsonData['result'],
      skipped: jsonData['skipped'],
      hidden: jsonData['hidden'],
      type: jsonData['type'],
      time: jsonData['time'],
    );
  }

  GroupEvent _parseGroupEvent(Map<String, dynamic> jsonData) {
    return GroupEvent(
      id: jsonData['group']['id'],
      suiteID: jsonData['group']['suiteID'],
      parentID: jsonData['group']['parentID'],
      name: jsonData['group']['name'],
      metadata: Metadata(
        skip: jsonData['group']['metadata']['skip'],
        skipReason: jsonData['group']['metadata']['skipReason'],
      ),
      testCount: jsonData['group']['testCount'],
      line: jsonData['group']['line'],
      column: jsonData['group']['column'],
      url: jsonData['group']['url'],
      type: jsonData['type'],
      time: jsonData['time'],
    );
  }

  DoneEvent _parseDoneEvent(Map<String, dynamic> jsonData) {
    return DoneEvent(success: jsonData['success'], type: jsonData['type'], time: jsonData['time']);
  }
}
