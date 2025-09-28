import 'tests/test_state.dart';

class AppState {
  final Map<String, Map<String, TestState>> tests = {};
  int index = 0;
  String statusLine = '';

  List<TestState> get testsList {
    return tests.values.expand((file) {
      return file.values;
    }).toList();
  }

  void updateTestState(String filePath, String testName, TestState testState) {
    if (!tests.containsKey(filePath)) {
      tests[filePath] = {};
    }
    tests[filePath]![testName] = testState;
  }

  TestTreeData? tree;
}

class TestTreeData {
  final String? testFile;
  final String? testName;
  final TestState? state;
  final List<TestTreeData> children;

  TestTreeData({this.testFile, this.state, this.testName, this.children = const []});
}
