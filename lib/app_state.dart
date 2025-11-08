import 'tests/test_state.dart';

class AppState {
  final Map<String, Map<String, NodeState>> tests = {};
  int index = 0;
  String statusLine = '';
  Duration time = Duration.zero;
  final List<String> logs = [];

  List<NodeState> get testsList {
    return tests.values.expand((file) {
      return file.values;
    }).toList();
  }

  void updateTestState(String filePath, String testName, NodeState testState) {
    if (!tests.containsKey(filePath)) {
      tests[filePath] = {};
    }
    tests[filePath]![testName] = testState;
  }

  TestTreeData? tree;
}

enum NodeType { root, folder, file, group, test }

class TestTreeData {
  final NodeState state;
  final NodeType type;
  final List<TestTreeData> children;

  TestTreeData({required this.type, required this.state, this.children = const []});
}
