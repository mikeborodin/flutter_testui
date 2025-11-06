import 'package:testui3/app_state.dart';
import 'package:testui3/tests/test_events.dart';
import 'package:testui3/tests/test_state.dart';

import 'entities.dart';
import 'utils.dart';

class TestEventProcessor {
  final AppState state;

  TestEventProcessor({required this.state});

  final List<dynamic> history = [];

  final Map<int, String> files = {};
  final Map<int, Group> groups = {};
  final Map<int, UnitTestState> testDetails = {};

  void process(dynamic event) {
    _set(event);

    state.logs.add('Event: ${event.type}');

    state.tree = buildTree();

    history.add(event);
  }

  /// Builds a tree based on current state of `files`, `groups`, `testDetails`
  /// Uses `convertPathsToFsTree` function to build file tree of parent folders
  /// * Should update parent folders' state fields `isRunning` and `result` based on children: example shuld set result of a folder in case all children are green
  //  * Should also count for nested groups (test groups should be reflected properly in the tree)
  /// * For unit tests within the same file that start with the same prefix it shuld also be relected as a node in the tree so that we avoid duplication when seeing the names
  /// Resulting tree be structured like
  /// Example hierarchy:
  ///    - folder name
  ///       - test file a
  ///          - group name (e.g. Mapper)
  ///             - mapper should
  ///                - do validation
  ///                - map entries x to y
  TestTreeData buildTree() {
    final root = TestTreeData(
      type: NodeType.root,
      state: NodeState(name: '🌳', isRunning: false, result: null, skipped: false),
      children: [],
    );

    final fileEntities = convertPathsToFsTree(files);

    for (var fileEntity in fileEntities) {
      final fileNode = TestTreeData(
        type: NodeType.file,
        state: NodeState(name: "${fileEntity.path} (id:${fileEntity.fileId})", isRunning: false, result: null, skipped: false),
        children: _buildChildren(fileEntity),
      );

      root.children.add(fileNode);
    }

    return root;
  }

  List<TestTreeData> _buildChildren(FileSystemEntity fileEntity) {
    final children = <TestTreeData>[];

    for (final group in groups.values.where((g) => g.fileId == fileEntity.fileId)) {
      final groupNode = TestTreeData(
        type: NodeType.group,
        state: NodeState(name: group.name, isRunning: false, result: null, skipped: false),
        children: [],
      );

      for (var test in testDetails.values.where(
        (t) => t.fileId == fileEntity.fileId && !t.hidden,
      )) {
        final testNode = TestTreeData(
          type: NodeType.test,
          state: NodeState(name: test.name, isRunning: false, result: test.result, skipped: false),
          children: [],
        );

        if (group.name.isNotEmpty) {
          groupNode.children.add(testNode);
        } else {
          children.add(testNode);
        }
      }

      if (groupNode.children.isNotEmpty) children.add(groupNode);
    }

    return children;
  }

  void _set(event) {
    if (event is StartEvent) {
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

      groups[event.id] = Group(
        name: event.name,
        parentGroup: event.parentID,
        fileId: event.suiteID,
      );
    }
    if (event is TestStartEvent) {
      if (!event.name.startsWith('loading ')) {
        state.statusLine = 'test start';
        testDetails[event.id] = UnitTestState(
          fileId: event.suiteID,
          startedAt: event.time,
          name: event.name,
        );
      }
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
