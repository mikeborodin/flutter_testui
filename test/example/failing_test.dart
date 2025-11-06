import 'package:test/test.dart';

void main() {
  test('should fail', () {
    expect(true, false);
  });

  test('ok test', () {
    expect(true, true);
  });

  group('group1', () {
    test('child 1', () {
      expect(true, true);
    });
    test('child 2', () {
      expect(true, true);
    });
  });
}
