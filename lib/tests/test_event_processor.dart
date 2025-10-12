import 'package:testui3/app_state.dart';
import 'package:testui3/tests/test_events.dart';
import 'package:testui3/tests/test_state.dart';

class Group {
  final int? parentGroup;
  final int fileId;

  Group({required this.parentGroup, required this.fileId});
}

class UnitTestState {
  final int fileId;
  final int startedAt;
  final String name;
  int? finishedAt;
  bool hidden = false;
  TestResult? result;

  UnitTestState({required this.fileId, required this.startedAt, required this.name});
}

class FileSystemEntity {
  final String name;
  final int? fileId;

  // if set this is is a folder, otherwise a file.
  List<FileSystemEntity> children;

  FileSystemEntity({required this.name, this.fileId, required this.children});
}

class TestEventProcessor {
  final AppState state;

  TestEventProcessor({required this.state});

  final List<dynamic> history = [];

  final Map<int, String> files = {};
  final Map<int, Group> groups = {};
  final Map<int, UnitTestState> testDetails = {};

  void process(dynamic event) {
    _set(event);

    // state.logs.add('event ${event.type} - ${event.toJson()}');
    history.add(event);
  }

  

  /// Builds a tree based on current state of `files`, `groups`, `testDetails`
  /// Uses `convertPathsToFsTree` function to build file tree of parent folders
  /// Should update parent folders' state fields `isRunning` and `result` based on children: example shuld set result of a folder in case all children are green   
  TestTreeData buildTree(){

  }

  void _set(event) {
    if (event is StartEvent) {
      history.clear();
      state.logs.clear();
      files.clear();

      state.statusLine =
          'start event; runner ${event.runnerVersion} protocol: ${event.protocolVersion}';

      state.tree = TestTreeData(
        type: NodeType.root,
        state: NodeState(name: 'root', isRunning: true, result: null, skipped: false),
        children: [],
      );
    }
    if (event is SuiteEvent) {
      state.statusLine = 'Suite event ${event.path}';
      files[event.id] = event.path;
    }
    if (event is GroupEvent) {
      state.statusLine = 'group event;';

      groups[event.id] = Group(parentGroup: event.parentID, fileId: event.suiteID);
    }
    if (event is TestStartEvent) {
      state.statusLine = 'test start';

      testDetails[event.id] = UnitTestState(
        fileId: event.suiteID,
        startedAt: event.time,
        name: event.name,
      );
    }
    if (event is TestDoneEvent) {
      state.statusLine = 'test done';
      testDetails[event.testID]?.finishedAt = event.time;

      if (event.result == 'success') {
        testDetails[event.testID]?.result = TestResult.passed;
      } else if (event.skipped) {
        testDetails[event.testID]?.result = TestResult.skipped;
      } else if (event.result == 'failure') {
        testDetails[event.testID]?.result = TestResult.failed;
      }

      testDetails[event.testID]?.finishedAt = event.time;
      testDetails[event.testID]?.hidden = event.hidden;
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
  }
}
