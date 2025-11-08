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

void fillChildrenFor(FileSystemEntity parentFolder, List<String> fileToSplit, int endFileId) {
  if (fileToSplit.length == 1) {
    final name = fileToSplit.firstOrNull ?? '';
    final file = FileSystemEntity(
      name: name,
      path: [parentFolder.path, ...fileToSplit].join('/'),
      fileId: endFileId,
      children: [],
    );
    if (!parentFolder.children.any((n) => n.name == name)) {
      parentFolder.children.add(file);
    }
  } else if (fileToSplit.length > 1) {
    final name = fileToSplit.firstOrNull ?? '';

    final folder = FileSystemEntity(
      name: name,
      path: [parentFolder.path, ...fileToSplit].join('/'),
      fileId: null,
      children: [],
    );
    fillChildrenFor(folder, fileToSplit.sublist(1), endFileId);

    if (!parentFolder.children.any((n) => n.name == name)) {
      parentFolder.children.add(folder);
    }
  }
}

List<FileSystemEntity> convertPathsToFsTree(Map<int, String> fullPaths) {
  final List<FileSystemEntity> list = [];

  Map<String, FileSystemEntity> rootFolders = {};
  for (var entry in fullPaths.entries) {
    final pathComponents = entry.value.split('/');

    if (pathComponents.length > 1) {
      final path = pathComponents.firstOrNull ?? '<error>';
      final folder = rootFolders.putIfAbsent(path, () {
        return FileSystemEntity(name: path, path: path, fileId: null, children: []);
      });

      fillChildrenFor(folder, pathComponents.sublist(1), entry.key);
    } else if (pathComponents.length == 1) {
      final file = FileSystemEntity(
        name: entry.value,
        path: pathComponents.join('/'),
        fileId: entry.key,
        children: [],
      );

      list.add(file);
    }
  }
  for (final f in rootFolders.values) {
    list.add(f);
  }

  return list;
}
