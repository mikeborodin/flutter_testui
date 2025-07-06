import 'test_state.dart';

class AppState {
  final Map<String, Map<String, TestState>> tests = {};
  String statusLine = '';

  void updateTestState(String filePath, String testName, TestState testState) {
    if (!tests.containsKey(filePath)) {
      tests[filePath] = {};
    }
    tests[filePath]![testName] = testState;
  }
}
