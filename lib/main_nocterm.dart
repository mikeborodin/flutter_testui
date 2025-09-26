import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:consola/consola.dart';
import 'package:hotreloader/hotreloader.dart';
import 'package:nocterm/nocterm.dart';
import 'package:testui3/app_state.dart';
import 'package:testui3/tests/test_event_mapper.dart';
import 'package:testui3/tests/test_runner.dart';

void main(List<String> args) async {
  final reloader = await HotReloader.create();

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
  final List<String> screen = [];
  final scrollController = ScrollController();

  @override
  void initState() {
    state.tests.clear();

    final eventProcessor = TestEventMapper(state);

    final timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        screen.add('hello ${timer.tick}');
      });
    });

    // sub = runner.stream.listen((event) {
    //   setState(() {
    //     state.statusLine = event.toString();
    //     eventProcessor.process(event);
    //   });
    // });
    // runner.runAll();

    super.initState();
  }

  @override
  void dispose() {
    sub?.cancel();
    super.dispose();
  }

  void _handleKeyEvent(KeyboardEvent event) {
    final height = Console.getWindowHeight();
    setState(() {
      if (event.character == 'q') {
        stdout.write('${ConsoleStrings.eraseScreen}${ConsoleStrings.cursorToHome}');
        exit(0);
      }

      if (event.character == 'r') {
        runner.runAll();
      }

      if (event.character == 'u') {
        if (position > 0) {
          position--;

          if (position == scrollController.offset - 1) {
            scrollController.scrollUp();
          }
        }
      }

      if (event.character == 'e') {
        if (position + 1 < screen.length) {
          position++;

          if (position >= height - 1) {
            scrollController.scrollDown();
          }
        }
      }

      if (event.logicalKey == LogicalKey.escape || event.matches(LogicalKey.keyQ)) {
        exit(0);
      }
    });
  }

  @override
  Component build(BuildContext context) {
    final height = Console.getWindowHeight();

    return Focusable(
      focused: true,
      onKeyEvent: (event) {
        _handleKeyEvent(event);
        return true;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 30,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (int i = 0; i < screen.length; i++)
                          Container(
                            color: i == position ? Colors.blue : null,
                            child: Text(' ${screen[i]}', style: TextStyle()),
                          ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(border: BoxBorder.all(color: Colors.blue)),
                    padding: EdgeInsets.all(2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [MarkdownText('')],
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
}
