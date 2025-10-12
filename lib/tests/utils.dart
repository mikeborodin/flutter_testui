import 'test_event_processor.dart';

List<String> removeCwdPrefix(List<String> input, String? cwd) {
  if (cwd == null || cwd.isEmpty) return input;

  return input.map((path) {
    if (path.startsWith(cwd)) {
      return path.substring(cwd.length);
    }
    return path;
  }).toList();
}

List<FileSystemEntity> fromFullPaths(List<String> fullPaths) {
  final Map<String, FileSystemEntity> rootEntities = {};

  for (var path in fullPaths) {
    final parts = path.split('/');
    Map<String, FileSystemEntity> currentLevel = rootEntities;

    for (var i = 0; i < parts.length; i++) {
      final part = parts[i];
      if (!currentLevel.containsKey(part)) {
        currentLevel[part] = FileSystemEntity(name: part, children: []);
      }

      if (i < parts.length - 1) {
        currentLevel = {for (var child in currentLevel[part]?.children ?? []) child.name: child};
      }
    }
  }

  return rootEntities.values.toList();
}
