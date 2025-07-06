import 'dart:async';

class TestRunner {
  final StreamController<String> _controller = StreamController<String>();

  Stream<String> runAll() {
    // Simulate running tests and sending updates
    Timer.periodic(Duration(seconds: 1), (timer) {
      _controller.add('Test update at ${DateTime.now()}');
    });
    return _controller.stream;
  }

  void stopAll() {
    // Stop all tests and close the stream
    _controller.close();
  }
}
