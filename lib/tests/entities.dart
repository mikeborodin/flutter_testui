import 'test_events.dart';

class Group {
  final int? parentGroup;
  final int fileId;
  final String name;

  Group({required this.name, required this.parentGroup, required this.fileId});
}

class UnitTestState {
  final int fileId;
  final int startedAt;
  final String name;
  int? finishedAt;
  bool hidden = false;
  TestResult? result;

  UnitTestState({required this.fileId, required this.startedAt, required this.name});
}

class FileSystemEntity {
  final String name;
  final String path;
  final int? fileId;

  // if set this is is a folder, otherwise a file.
  List<FileSystemEntity> children;

  FileSystemEntity({required this.name, required this.path, this.fileId, required this.children});
}
