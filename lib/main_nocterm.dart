import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:consola/consola.dart';
import 'package:hotreloader/hotreloader.dart';
import 'package:nocterm/nocterm.dart';
import 'package:testui3/app_state.dart';
import 'package:testui3/tests/test_event_mapper.dart';
import 'package:testui3/tests/test_runner.dart';
import 'package:testui3/tests/test_state.dart';
import 'package:testui3/tree.dart';
import 'package:testui3/ui/icons.dart';

void main(List<String> args) async {
  final HotReloader? reloader;

  reloader = await HotReloader.create();

  final parser = ArgParser()..addOption('command', abbr: 'c', defaultsTo: 'dart test -r json');
  final argResults = parser.parse(args);
  final testCommand = argResults['command'] as String;
  await runApp(App(runner: TestRunner(testCommand)));

  reloader.stop();
}

class App extends StatefulComponent {
  final TestRunner runner;
  const App({super.key, required this.runner});

  @override
  State<App> createState() => _AppState(runner: runner);
}

class _AppState extends State<App> {
  TestRunner runner;
  _AppState({required this.runner});

  final AppState state = AppState();
  StreamSubscription<dynamic>? sub;

  int position = 0;
  final scrollController = ScrollController();
  bool detailsVisible = true;

  TreeNode? testTreeState;
  TreeNode? selectedNode;

  @override
  void initState() {
    final eventProcessor = TestEventMapper(state);

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

  void _handleKeyEvent(KeyboardEvent event) {
    // final height = Console.getWindowHeight();
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

      // if (event.character == 'u') {
      //   if (position > 0) {
      //     position--;
      //
      //     if (position == scrollController.offset - 1) {
      //       scrollController.scrollUp();
      //     }
      //   }
      // }
      //
      // if (event.character == 'e') {
      //   if (position + 1 < state.testsList.length) {
      //     position++;
      //
      //     if (position >= height - 1) {
      //       scrollController.scrollDown();
      //     }
      //   }
      // }
      //
      if (event.logicalKey == LogicalKey.escape || event.matches(LogicalKey.keyQ)) {
        exit(0);
      }
    });
  }

  @override
  Component build(BuildContext context) {
    // final width = Console.getWindowWidth();
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
        });

        return true;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: testTreeState != null
                      ? Container(
                          color: Colors.black,
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
                        )
                      : Text('loading...'),
                ),
                if (detailsVisible) VerticalDivider(),
                if (detailsVisible)
                  Container(
                    width: 60,
                    color: Colors.black,
                    padding: EdgeInsets.all(2),
                    child: Text(selectedNode?.children.length.toString() ?? 'nothing'),
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
    String icon(TestState testState) => testState.result == 'success'
        ? Icons.check
        : testState.result == 'running'
        ? Icons.inProgress
        : Icons.error;

    Color? color(TestState testState) => testState.result == 'success'
        ? Colors.green
        : testState.result == 'running'
        ? null
        : Colors.red;

    String name = '';
    if (root.state?.name != null) {
      name = ' ${icon(root.state!)} ${root.state!.name}';
    } else if (root.testFile != null) {
      name = root.testFile!;
    }

    return TreeNode(
      child: name.isNotEmpty
          ? Text(
              name,
              maxLines: 1,
              style: TextStyle(color: root.state != null ? color(root.state!) : null),
            )
          : Divider(),
      children: [for (final child in root.children) buildTree(child)],
    );
  }
}
