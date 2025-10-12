import 'dart:async';
import 'dart:io';

import 'package:consola/consola.dart';
import 'package:nocterm/nocterm.dart';
import 'package:testui3/app_state.dart';
import 'package:testui3/tests/test_event_processor.dart';
import 'package:testui3/tests/test_events.dart';
import 'package:testui3/tests/test_runner.dart';
import 'package:testui3/tests/test_state.dart';
import 'package:testui3/tree.dart';
import 'package:testui3/ui/icons.dart';

class TestUiApp extends StatefulComponent {
  final TestRunner runner;
  const TestUiApp({super.key, required this.runner});

  @override
  State<TestUiApp> createState() => _TestUiAppState(runner: runner);
}

class _TestUiAppState extends State<TestUiApp> {
  TestRunner runner;
  _TestUiAppState({required this.runner});

  final AppState state = AppState();
  StreamSubscription<dynamic>? sub;

  int position = 0;
  final scrollController = ScrollController();
  bool detailsVisible = false;
  bool logsVisible = false;

  TreeNode? testTreeState;
  TreeNode? selectedNode;

  @override
  void initState() {
    final eventProcessor = TestEventProcessor(state: state);

    runner.runAll();
    setState(() {
      state.statusLine = 'starting';
    });

    sub = runner.stream.listen((event) {
      setState(() {
        state.statusLine = event.toString();
        eventProcessor.process(event);

        testTreeState = state.tree != null
            ? buildTree(state.tree!)
            : TreeNode(child: Text('Test tree loading...'), children: []);
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    sub?.cancel();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    return Focusable(
      focused: true,
      onKeyEvent: (event) {
        setState(() {
          if (event.character == 'q') {
            stdout.write('${ConsoleStrings.eraseScreen}${ConsoleStrings.cursorToHome}');
            exit(0);
          }

          if (event.character == 'r') {
            runner.runAll();
          }
          if (event.character == 'p') {
            detailsVisible = !detailsVisible;
          }

          if (event.matches(LogicalKey.escape)) {
            detailsVisible = false;
            logsVisible = false;
          }
          if (event.character == 'l') {
            logsVisible = !logsVisible;
          }
        });

        return true;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: testTreeState != null
                          ? Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(2),
                                    child: Tree(
                                      controller: scrollController,
                                      data: testTreeState!,
                                      onSelected: (v) {
                                        setState(() {
                                          selectedNode = v;
                                          detailsVisible = true;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Text('loading...'),
                    ),
                    if (detailsVisible && testTreeState != null) VerticalDivider(),
                    if (detailsVisible && testTreeState != null)
                      Container(
                        width: 60,
                        padding: EdgeInsets.all(2),
                        child: Text(selectedNode?.children.length.toString() ?? 'nothing'),
                      ),
                  ],
                ),
                if (logsVisible)
                  Container(
                    color: Color.defaultColor,
                    child: SizedBox(
                      height: 20,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [for (final log in state.logs) Text(log)],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Container(color: Colors.black, child: Text(state.statusLine)),
        ],
      ),
    );
  }

  TreeNode buildTree(TestTreeData root) {
    String icon(NodeState testState) {
      if (testState.isRunning) return Icons.inProgress;
      if (testState.result == TestResult.passed) return Icons.check;
      if (testState.result == TestResult.failed) return Icons.error;

      return '';
    }

    Color? color(NodeState testState) {
      if (testState.result == TestResult.passed) return Colors.green;
      if (testState.result == TestResult.failed) return Colors.red;
      return null;
    }

    String name = ' ${root.state != null ? icon(root.state) : ''} ${root.state.name}';

    return TreeNode(
      child: name.isNotEmpty
          ? Text(
              name,
              maxLines: 1,
              style: TextStyle(color: root.state != null ? color(root.state) : null),
            )
          : Divider(),
      children: [for (final child in root.children) buildTree(child)],
    );
  }
}
