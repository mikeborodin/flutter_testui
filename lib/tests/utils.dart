import 'entities.dart';

List<String> removeCwdPrefix(List<String> input, String? cwd) {
  if (cwd == null || cwd.isEmpty) return input;

  return input.map((path) {
    if (path.startsWith(cwd)) {
      return path.substring(cwd.length);
    }
    return path;
  }).toList();
}

List<FileSystemEntity> convertPathsToFsTree(Map<int, String> fullPaths) {
  final Map<String, FileSystemEntity> rootEntities = {};

  for (var entry in fullPaths.entries) {
    // final pathComponents = entry.value.split('/');
    final pathComponents = [entry.value];
    Map<String, FileSystemEntity> currentLevel = rootEntities;

    for (var i = 0; i < pathComponents.length; i++) {
      final part = pathComponents[i];

      if (!currentLevel.containsKey(part)) {
        currentLevel[part] = FileSystemEntity(
          name: part,
          path: entry.value,
          fileId: entry.key,
          children: [],
        );
      }

      if (i < pathComponents.length - 1) {
        currentLevel = {for (var child in currentLevel[part]?.children ?? []) child.name: child};
      }
    }
  }

  return rootEntities.values.toList();
}
