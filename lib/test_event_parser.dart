import 'dart:convert';
import 'test_events.dart';

class TestEventParser {
  dynamic parseEvent(String jsonLine) {
    final Map<String, dynamic> jsonData = json.decode(jsonLine);

    switch (jsonData['type']) {
      case 'start':
        return StartEvent(
          protocolVersion: jsonData['protocolVersion'],
          runnerVersion: jsonData['runnerVersion'],
          pid: jsonData['pid'],
          type: jsonData['type'],
          time: jsonData['time'],
        );
      case 'suite':
        return SuiteEvent(
          id: jsonData['suite']['id'],
          platform: jsonData['suite']['platform'],
          path: jsonData['suite']['path'],
          type: jsonData['type'],
          time: jsonData['time'],
        );
      case 'testStart':
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
      case 'allSuites':
        return AllSuitesEvent(
          count: jsonData['count'],
          type: jsonData['type'],
          time: jsonData['time'],
        );
      case 'testDone':
        return TestDoneEvent(
          testID: jsonData['testID'],
          result: jsonData['result'],
          skipped: jsonData['skipped'],
          hidden: jsonData['hidden'],
          type: jsonData['type'],
          time: jsonData['time'],
        );
      case 'group':
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
      case 'done':
        return DoneEvent(
          success: jsonData['success'],
          type: jsonData['type'],
          time: jsonData['time'],
        );
      default:
        throw Exception('Unknown event type: ${jsonData['type']}');
    }
  }
}
