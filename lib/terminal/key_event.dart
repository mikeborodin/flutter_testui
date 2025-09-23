enum KeyType {
  // Control keys
  character,
  enter,
  escape,
  backspace,
  tab,
  insert,
  delete,
  home,
  end,
  pageUp,
  pageDown,

  // Arrow keys
  arrowUp,
  arrowDown,
  arrowLeft,
  arrowRight,

  // Function keys
  f1,
  f2,
  f3,
  f4,
  f5,
  f6,
  f7,
  f8,
  f9,
  f10,
  f11,
  f12,

  // Modifier combinations

  // Control + character (e.g. Ctrl+A)
  ctrl,

  // Shift + character (e.g. Shift+A)
  shift,

  // Alt + character (e.g. Alt+A)
  alt,

  // Meta/Command + character (e.g. Command+A)
  meta,

  unknown,
}

class KeyEvent {
  final KeyType type;
  final String? character;

  KeyEvent(this.type, [this.character]);

  factory KeyEvent.fromBytes(List<int> bytes) {
    if (bytes.isEmpty) return KeyEvent(KeyType.unknown);

    final controlKeys = {
      10: KeyType.enter,
      13: KeyType.enter,
      27: KeyType.escape,
      127: KeyType.backspace,
      9: KeyType.tab,
    };

    if (bytes.length == 1) {
      final byte = bytes[0];
      if (byte < 32) {
        return KeyEvent(controlKeys[byte] ?? KeyType.ctrl, String.fromCharCode(byte + 64));
      }
      return KeyEvent(KeyType.character, String.fromCharCode(byte));
    }

    if (bytes[0] == 27 && bytes.length == 3 && bytes[1] == 91) {
      final extendedKeys = {
        65: KeyType.arrowUp,
        66: KeyType.arrowDown,
        67: KeyType.arrowRight,
        68: KeyType.arrowLeft,
        70: KeyType.end,
        72: KeyType.home,
        50: KeyType.insert,
        51: KeyType.delete,
        53: KeyType.pageUp,
        54: KeyType.pageDown,
      };
      return KeyEvent(extendedKeys[bytes[2]] ?? KeyType.unknown);
    }

    if (bytes[0] == 27 && bytes.length >= 3 && (bytes[1] == 79 || bytes[1] == 91)) {
      final functionKeys = {80: KeyType.f1, 81: KeyType.f2, 82: KeyType.f3, 83: KeyType.f4};
      return KeyEvent(functionKeys[bytes[2]] ?? KeyType.unknown);
    }

    return KeyEvent(KeyType.unknown);
  }

  @override
  String toString() {
    switch (type) {
      case KeyType.ctrl:
      case KeyType.shift:
      case KeyType.alt:
      case KeyType.meta:
        return 'KeyEvent(${type.toString().split('.').last}+${character ?? ''})';
      case KeyType.character:
        return 'KeyEvent(${character ?? ''})';
      default:
        return 'KeyEvent(${type.toString().split('.').last})';
    }
  }
}
